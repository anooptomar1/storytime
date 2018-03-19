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
