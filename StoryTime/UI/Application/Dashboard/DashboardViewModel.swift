//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

class DashboardViewModel: ViewModelCore {
    
    let printerService: PrinterService
    
    public enum Action {
        case onAr
        case onSticker
        case onStory
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    override init() {
        printerService = try! AppDelegate.container.resolve() as PrinterService
    }
    
    public func onPairDevice() {
        printerService.searchNetworkPrinter()
    }
    
    public func onPrint() {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
        let robotImage = UIImage(named: "Robot")!
        let size = CGSize(width: robotImage.size.width, height: robotImage.size.height)
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        robotImage.draw(in: rect, blendMode: .normal, alpha: 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        context?.stroke(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        _ = printerService.printContent(image: newImage!, printer: printer)
            .subscribe(
                onSuccess: { _ in
                },
                onError: { _ in
                })
    }
    
    public func onAr() {
        _action.onNext(.onAr)
    }
    
    public func onStickerSelection() {
        _action.onNext(.onSticker)
    }
    
    public func onStory() {
        _action.onNext(.onStory)
    }
    
    
}
