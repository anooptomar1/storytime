//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class PrinterServiceImpl: NSObject, PrinterService {
//    private let printQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).printQueue")
    private let scheduler = SerialDispatchQueueScheduler(qos: .background, internalSerialQueueName: "\(Bundle.main.bundleIdentifier!).printQueueInternal")
    private let networkManager = BRPtouchNetworkManager()
    
    private let disposeBag = DisposeBag()
    
    private let supportedPrinter = [
        "Brother QL-710W",
        "Brother QL-720NW",
        "Brother QL-810W",
        "Brother QL-820NWB"
    ]
    
    private let networkPrinters = Variable([Printer]())
    private let bluetoothPrinters = Variable([Printer]())
    
    public let printers: Variable<[Printer]> = Variable([])
    
    override init() {
        super.init()
        
        initBRPNetworkManager()
        
        Observable
            .combineLatest(
                networkPrinters.asObservable(),
                bluetoothPrinters.asObservable()
            )
            .map { [unowned self] (networkPrinterList, bluetoothPrinterList) in
                self.printers.value = networkPrinterList + bluetoothPrinterList
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        
        Observable
            .merge([
                NotificationCenter.default.rx.notification(NSNotification.Name.BRDeviceDidConnect),
                NotificationCenter.default.rx.notification(NSNotification.Name.BRDeviceDidDisconnect),
            ])
            .map { self.handleDeviceListChange($0) }
            // don't let it error out. We want to keep this connected.
            .retry()
            .subscribe()
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.BRPtouchPrinterKitMessage)
            .subscribe(onNext: { notification in
                guard let message = notification.userInfo?[BRMessageKey] else {
                    return
                }
                print("message: \(message)")
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.BRBluetoothSessionBytesWritten)
            .subscribe(onNext: { notification in
                guard let written = notification.userInfo?[BRBytesWrittenKey] else {
                    return
                }
                print("BT bytes written: \(written)")
            })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(NSNotification.Name.BRWLanConnectBytesWritten)
            .subscribe(onNext: { notification in
                guard let written = notification.userInfo?[BRBytesWrittenKey] else {
                    return
                }
                print("WLAN bytes written: \(written)")
            })
            .disposed(by: disposeBag)
        
        // register after the notification is wired up so we don't miss any notifications.
        BRPtouchBluetoothManager.shared()?.registerForBRDeviceNotifications()
        
        // make sure the list is up to date with what is already connected.
        handleDeviceList()
        
        // search network for brother printer.
        searchNetworkPrinter()
    }
    
    public func availablePrinter() -> Observable<[Printer]> {
        return printers.asObservable()
    }
    
    public func pairPrinter() {
        let predicate = NSPredicate { [unowned self] evaluatedObject, dictionary in
            guard let evaluatedObject = evaluatedObject as? String else {
                return false
            }
            
            let filtered = self.supportedPrinter.filter { $0.hasPrefix(evaluatedObject) }
            return filtered.count > 0
        }
        
        BRPtouchBluetoothManager.shared()?.brShowBluetoothAccessoryPicker(withNameFilter: predicate)
    }
    
    public func printContent(image: UIImage, printer: Printer, orientation: PrinterOrientation) -> Single<Bool> {
        let maxRetry = 4
        // let scheduler = SerialDispatchQueueScheduler(queue: printQueue, internalSerialQueueName: "\(Bundle.main.bundleIdentifier!).printQueueInternal")
        return Single<BRPtouchPrinter>
            .create { observer in
                var ptp: BRPtouchPrinter?
                
                switch printer.connectionType {
                    case .bluetooth:
                        print("Preparing BRPtouchPrinter with Bluetooth")
                        ptp = BRPtouchPrinter(printerName: printer.deviceName, interface: CONNECTION_TYPE.BLUETOOTH)
                        
                        print("setupForBluetoothDevice")
                        ptp?.setupForBluetoothDevice(withSerialNumber: printer.serialNumber)
                    case .wifi:
                        print("Preparing BRPtouchPrinter with WLAN")
                        ptp = BRPtouchPrinter(printerName: printer.model, interface: CONNECTION_TYPE.WLAN)
                        
                        print("setIPAddress")
                        ptp?.setIPAddress(printer.ip!)
                }
                

                if printer.model.starts(with: "RJ-4030Ai") {
                    ptp?.setPrintInfo(self.printerWideConfig(orientation: orientation))
                    ptp?.setCustomPaperFile(Bundle.main.path(forResource: "rj4030ai_102mm", ofType: "bin")!)
                } else {
                    ptp?.setPrintInfo(self.printerConfig(orientation: orientation))
                }
                
                if ptp == nil {
                    observer(.error(NSError(domain: "PrinterService", code: -1, userInfo: ["message": "Prepare Print Error"])))
                } else {
                    observer(.success(ptp!))
                }
                
                return Disposables.create()
            }
            // only allow 1 print operation at a time.
            .observeOn(scheduler)
            .flatMap { ptp in
                return  Single<BRPtouchPrinter>
                    .just(ptp)
                    .map { ptp in
                        print("isPrinterReady")
                        guard ptp.isPrinterReady() else {
                            throw NSError(domain: "PrinterService", code: -2, userInfo: ["message": "Printer is not Ready"])
                        }
                        
                        print("startCommunication")
                        ptp.endCommunication() // sometime it gets in to a weird mode where the endCommunication isn't working.
                        guard ptp.startCommunication() else {
                            ptp.endCommunication()
                            throw NSError(domain: "PrinterService", code: -3, userInfo: ["message": "Communication Error"])
                        }
                        
                        print("print")
                        let result = ptp.print(image.cgImage, copy: 1)
                        guard result == ERROR_NONE_ else {
                            print("RESULT: \(result)")
                            throw NSError(domain: "PrinterService", code: -4, userInfo: ["message": "Printing Error \(result)"])
                        }
                        
                        print("endCommunication")
                        ptp.endCommunication()
                        
                        return true
                    }
                    // retry with some back off to give the printer some time to recover.
                    .retryWhen { [unowned self] (errors: Observable<Error>) in
                        return errors
                            .enumerated()
                            .flatMap { (index, error) -> Observable<Int64> in
                                if index >= maxRetry - 1 {
                                    return Observable.error(error)
                                }
                                
                                return Observable<Int64>.timer(RxTimeInterval((index + 1) * 1), scheduler: self.scheduler)
                            }
                    }
            }
            .debug()
        
    }
    
    private func handleDeviceListChange(_ notification: Notification) {
        guard notification.userInfo?[BRDeviceKey] != nil else {
            return
        }
        
        handleDeviceList()
    }
    
    private func handleDeviceList() {
        self.bluetoothPrinters.value = (BRPtouchBluetoothManager.shared()?.pairedDevices() as? [BRPtouchDeviceInfo] ?? [])
            .map { (info: BRPtouchDeviceInfo) in Printer(connectionType: .bluetooth, model: info.strModelName, serialNumber: info.strSerialNumber) }
    }
    
    // FIXME hack to get this working for now.
    private func printerConfig(orientation: PrinterOrientation) -> BRPtouchPrintInfo {
        let printInfo = BRPtouchPrintInfo()
        
        printInfo.strPaperName = "62mm"
        printInfo.nPrintMode = PRINT_FIT
        printInfo.nAutoCutFlag = OPTION_AUTOCUT
        printInfo.nHalftone = HALFTONE_DITHER
        
        switch orientation {
            case .portrait: printInfo.nOrientation = ORI_PORTRATE
            case .landscape: printInfo.nOrientation = ORI_LANDSCAPE
        }
        
        printInfo.nSpeed = 0
        printInfo.nDensity = 9
        
        return printInfo
    }
    
    private func printerWideConfig(orientation: PrinterOrientation) -> BRPtouchPrintInfo {
        let printInfo = BRPtouchPrintInfo()
        
        printInfo.strPaperName = "CUSTOM" // "62mm"
        printInfo.nPrintMode = PRINT_FIT
        printInfo.nHalftone = HALFTONE_DITHER
    
        switch orientation {
            case .portrait: printInfo.nOrientation = ORI_PORTRATE
            case .landscape: printInfo.nOrientation = ORI_LANDSCAPE
        }
    
        printInfo.nSpeed = 0
        printInfo.nDensity = 0
        
        return printInfo
    }
}

extension PrinterServiceImpl: BRPtouchNetworkDelegate {
    private func initBRPNetworkManager() {
        networkManager.delegate = self
    }
    
    public func searchNetworkPrinter() {
        self.networkManager.setPrinterNames(self.supportedPrinter)
        self.networkManager.startSearch(5)
    }
    
    public func didFinishSearch(_ sender: Any!) {
        networkPrinters.value = (self.networkManager.getPrinterNetInfo() as? [BRPtouchDeviceInfo] ?? [])
            .map { (info: BRPtouchDeviceInfo) in Printer(connectionType: .wifi, model: info.strModelName, serialNumber: info.strSerialNumber, ip: info.strIPAddress) }
    }
}