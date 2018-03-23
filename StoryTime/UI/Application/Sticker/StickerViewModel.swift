//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

public class StickerViewModel: ViewModelCore {
    public static let stickers = Variable([StickerItemViewModel]())
    
    public enum Action {
        case close
        case add
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    private let printerService: PrinterService
    
    override init() {
        printerService = try! AppDelegate.container.resolve() as PrinterService
        
        if StickerViewModel.stickers.value.count == 0 {
            let stickers = ["Bear", "Brother", "Chameleon", "Peace", "Penguin", "pikachu", "Robot", "building-01-a", "building-01-b", "building-01-c", "building-01-d", "Dragon"].map { (title: String) -> StickerItemViewModel in
                print(title)
                let sticker = Sticker(coverImage: UIImage(named: title)!, referenceImage: UIImage(named: title)!, assetKey: title, node: nil)
                return StickerItemViewModel(sticker)
            }
            StickerViewModel.stickers.value = stickers
        }
        
    }
    
    public func onPrint(sticker: Sticker) {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
        _ = printerService.printContent(image: sticker.referenceImage, printer: printer, orientation: .portrait)
            .subscribe(
                onSuccess: { _ in
                },
                onError: { _ in
                })
    }
    
    public func onClose() {
        _action.onNext(.close)
    }
    
    public func onAdd() {
        _action.onNext(.add)
    }
}
