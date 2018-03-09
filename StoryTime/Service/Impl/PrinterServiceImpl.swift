//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// https://github.com/Ayiga/cordova-brother-label-printer/blob/master/src/ios/BrotherPrinter.m

public class PrinterServiceImpl: PrinterService {
    private let printQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).printQueue")
    
    private let disposeBag = DisposeBag()
    
    private let supportedPrinter = [
        "Brother QL-710W",
        "Brother QL-720NW",
        "Brother QL-810W",
        "Brother QL-820NWB"
    ]
    
    
    init() {
        Observable
            .merge([
                NotificationCenter.default.rx.notification(NSNotification.Name.BRDeviceDidConnect),
                NotificationCenter.default.rx.notification(NSNotification.Name.BRDeviceDidDisconnect)
            ])
            .map { self.handleDeviceListChange($0) }
            // don't let it error out. We want to keep this connected.
            .retry()
            .subscribe()
            .disposed(by: disposeBag)
        
        // register after the notification is wired up so we don't miss any notifications.
        BRPtouchBluetoothManager.shared()?.registerForBRDeviceNotifications()
        
        // make sure the list is upto date with what is already connected.
        handleDeviceList()
    }
   
    public let printers: Variable<[Printer]> = Variable([])
    
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
    
    public func printContent(image: UIImage, printer: Printer) -> Single<Bool> {
        return Single<BRPtouchPrinter>
            .deferred {
                guard let ptp = BRPtouchPrinter(printerName: printer.deviceName, interface: CONNECTION_TYPE.BLUETOOTH) else {
                    throw NSError(domain: "PrinterService", code: -1, userInfo: ["message": "Prepare Print Error"])
                }
                
                return Single.just(ptp).do(onDispose: { ptp.endCommunication() })
            }
            .observeOn(SerialDispatchQueueScheduler(queue: printQueue, internalSerialQueueName: "\(Bundle.main.bundleIdentifier!).printQueueInternal"))
            .map { ptp in
                ptp.setupForBluetoothDevice(withSerialNumber: printer.serialNumber)
                ptp.setPrintInfo(self.printerConfig())
                
                
                // force anything weird going by forcing the communication to end before we start.
                ptp.endCommunication()
                
                guard ptp.isPrinterReady() else {
                    throw NSError(domain: "PrinterService", code: -2, userInfo: ["message": "Printer is not Ready"])
                }
                
                guard ptp.startCommunication() else {
                    throw NSError(domain: "PrinterService", code: -3, userInfo: ["message": "Communication Error"])
                }
                
                guard ptp.print(image.cgImage, copy: 1) == ERROR_NONE_ else {
                    throw NSError(domain: "PrinterService", code: -4, userInfo: ["message": "Printing Error "])
                }
                
                return true
            }
    }
    
    private func handleDeviceListChange(_ notification: Notification) -> [Printer] {
        guard let connectedAccessory = notification.userInfo?[BRDeviceKey] else {
            // something went wrong... we will just return an empty string.
            return []
        }
        print("ConnectDevice : \(String(describing: (connectedAccessory as? BRPtouchDeviceInfo)?.description()))")
        
        return handleDeviceList()
    }
    
    @discardableResult
    private func handleDeviceList() -> [Printer] {
        let result = (BRPtouchBluetoothManager.shared()?.pairedDevices() as? [BRPtouchDeviceInfo] ?? [])
            .map { (info: BRPtouchDeviceInfo) in Printer(model: info.strModelName, serialNumber: info.strSerialNumber) }
        
        self.printers.value = result
        
        return result
    }
    
    // FIXME hack to get this working for now.
    private func printerConfig() -> BRPtouchPrintInfo {
        let printInfo = BRPtouchPrintInfo()
        
        printInfo.strPaperName = "62mmRB"
        printInfo.nPrintMode = PRINT_FIT
        printInfo.nAutoCutFlag = OPTION_AUTOCUT
        printInfo.nHalftone = HALFTONE_BINARY
        
        return printInfo
    }
}