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
            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "Robot", backgroundColor: UIColor.tealish),
            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "StoryRobot", backgroundColor: UIColor.pumpkinOrange),
            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "Wine", backgroundColor: UIColor.sunYellow),
//            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "Robot", backgroundColor: UIColor.tealish),
//            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "Robot", backgroundColor: UIColor.pumpkinOrange),
//            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "Robot", backgroundColor: UIColor.sunYellow),
//            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "Robot", backgroundColor: UIColor.tealish),
//            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "Robot", backgroundColor: UIColor.pumpkinOrange),
//            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "Robot", backgroundColor: UIColor.sunYellow),
//            Effect(title: "BIRTHDAY", coverImage: UIImage(named: "firework")!, effect: "Robot", backgroundColor: UIColor.tealish),
//            Effect(title: "CELEBRATE", coverImage: UIImage(named: "cracker")!, effect: "Robot", backgroundColor: UIColor.pumpkinOrange),
//            Effect(title: "CONGRATS", coverImage: UIImage(named: "wine")!, effect: "Robot", backgroundColor: UIColor.sunYellow),
        ].map { EffectItemViewModel($0) }
    }
    
    public func onClose() {
        _action.onNext(.close)
    }
    
    func randomString(len: Int) -> String {
        
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0..<len {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    public func onCreate() {
        // hack!! :P
        let sticker = Sticker(coverImage: selectedImage.value!, referenceImage: selectedImage.value!, assetKey: selection.value!.effect, node: nil)
        ArViewController.stickers.value[randomString(len: 10)] = sticker
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
