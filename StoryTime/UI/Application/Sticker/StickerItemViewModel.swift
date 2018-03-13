//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

public class StickerItemViewModel: ViewModelCore {
    public let sticker: Sticker
    
    public var selected: Bool = false
    
    public init(_ sticker: Sticker) {
        self.sticker = sticker
    }
}
