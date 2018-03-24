//
// Created by Akito Nozaki on 3/15/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

class StoryPrintViewModel: ViewModelCore {
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
    public let story: Story
    
    public let stickers = Variable([StickerItemViewModel]())
    
    init(story: Story) {
        self.story = story
        
        printerService = try! AppDelegate.container.resolve() as PrinterService
        
        let stickers = story.sticker.map { (title: String) -> StickerItemViewModel in
            let sticker = Sticker(coverImage: UIImage(named: title)!, referenceImage: UIImage(named: title)!, assetKey: title, node: nil)
            return StickerItemViewModel(sticker)
        }
        
        self.stickers.value = stickers
    }
    
    public func onPrint(sticker: Sticker) {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
        let image = sticker.referenceImage
        
        _ = printerService.printContent(image: image, printer: printer, orientation: .portrait)
            .subscribe(
                onSuccess: { _ in
                },
                onError: { _ in
                })
    }
    
    public func onPrintStory() {
        guard let printer = printerService.printers.value.first else {
            return
        }
        
        _ = Observable.from(story.print)
            .concatMap { [unowned self] image in
                // FIXME this shouldn't be unowned :/
                return self.printerService.printContent(image: image, printer: printer, orientation: .landscape).asObservable()
            }
            .subscribe(
                onNext: { _ in
                },
                onError: { _ in
                })
    }
    
    public func onClose() {
        _action.onNext(.close)
    }
}
