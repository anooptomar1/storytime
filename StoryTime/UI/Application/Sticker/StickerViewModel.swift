//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

public class StickerViewModel: ViewModelCore {
    public enum Action {
        case close
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    private let printerService: PrinterService
    
    public let stickers = Variable([StickerItemViewModel]())
    
    override init() {
        printerService = try! AppDelegate.container.resolve() as PrinterService
        
        let stickers = ["Bear", "Brother", "Chameleon", "Peace", "Penguin", "pikachu", "Robot", "Samurai"].map { (title: String) -> StickerItemViewModel in
            let sticker = Sticker(coverImage: UIImage(named: title)!, referenceImage: UIImage(named: title)!, assetKey: title)
            return StickerItemViewModel(sticker)
        }
        
        self.stickers.value = stickers
    }
    
    public func onPrint(sticker: Sticker) {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
        _ = printerService.printContent(image: sticker.referenceImage, printer: printer)
            .subscribe(
                onSuccess: { _ in
                },
                onError: { _ in
                })
    }
    
    public func onClose() {
        _action.onNext(.close)
    }
}
