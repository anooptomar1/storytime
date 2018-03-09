//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

class DashboardViewModel: ViewModel {
    
    let printerService: PrinterService
    
    public enum Action {
        case onAr
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    
    init() {
        printerService = try! AppDelegate.container.resolve() as PrinterService
    }
    
    public func onPairDevice() {
        printerService.pairPrinter()
    }
    
    public func onPrint() {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
        _ = printerService.printContent(image: UIImage(named: "Robot")!, printer: printer)
            .subscribe(
                onSuccess: { _ in
                },
                onError: { _ in
                })
    }
    
    public func onAr() {
        _action.onNext(.onAr)
    }
}
