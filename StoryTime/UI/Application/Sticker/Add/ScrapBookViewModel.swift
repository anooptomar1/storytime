//
// Created by Akito Nozaki on 3/17/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjackSwift

class ScrapBookViewModel: ViewModelCore {
    public enum Action {
        case close
        case create(Sticker)
    }
    
    private let disposeBag = DisposeBag()
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    public let effects = Variable([EffectItemViewModel]())
    public let selection = Variable<Effect?>(nil)
    public let selectedImage = Variable<UIImage?>(nil)
    
    init(selectedImage: UIImage) {
        self.selectedImage.value = selectedImage
        super.init()
        
        effects.value = [
            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "firework", backgroundColor: UIColor.tealish),
            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "cracker", backgroundColor: UIColor.pumpkinOrange),
            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "wine", backgroundColor: UIColor.sunYellow),
            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "firework-a", backgroundColor: UIColor.tealish),
            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "cracker-a", backgroundColor: UIColor.pumpkinOrange),
            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "wine-b", backgroundColor: UIColor.sunYellow),
            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "firework-c", backgroundColor: UIColor.tealish),
            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "cracker-e", backgroundColor: UIColor.pumpkinOrange),
            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "wine-f", backgroundColor: UIColor.sunYellow),
            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "firework-g", backgroundColor: UIColor.tealish),
            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "cracker-h", backgroundColor: UIColor.pumpkinOrange),
            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "wine-i", backgroundColor: UIColor.sunYellow),
        ].map { EffectItemViewModel($0) }
    }
    
    public func onClose() {
        _action.onNext(.close)
    }
    
    public func onCreate() {
        // hack!! :P
        let sticker = Sticker(coverImage: selectedImage.value!, referenceImage: selectedImage.value!, assetKey: selection.value!.effect, node: nil)
        StickerViewModel.stickers.value.append(StickerItemViewModel(sticker))
        _action.onNext(.create(sticker))
    }
    
    public func onSelectEffect(effect: Effect) {
        self.effects.value.forEach { effectModel in
            effectModel.selected = effectModel.effect.effect == effect.effect
        }
        selection.value = effect
    }
    
}
