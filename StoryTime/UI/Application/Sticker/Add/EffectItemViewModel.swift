//
// Created by Akito Nozaki on 3/20/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

class EffectItemViewModel {
    public let effect: Effect
    public var selected: Bool
    
    public init(_ effect: Effect) {
        self.effect = effect
        self.selected = false
    }
}
