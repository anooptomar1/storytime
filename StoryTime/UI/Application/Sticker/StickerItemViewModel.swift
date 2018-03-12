//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

public class StickerItemViewModel {
    let sticker: Sticker
    
    var selected: Bool = false
    
    public init(_ sticker: Sticker) {
        self.sticker = sticker
    }
}
