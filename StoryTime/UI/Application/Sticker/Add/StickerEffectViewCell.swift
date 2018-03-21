//
// Created by Akito Nozaki on 3/20/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

class StickerEffectViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    public func update(effect: EffectItemViewModel) {
        self.backgroundColor = effect.effect.backgroundColor
        self.coverImageView.image = effect.effect.coverImage
        self.labelView.text = effect.effect.title
        
        if effect.selected {
            self.layer.borderColor = UIColor.warmGrey.cgColor
            self.layer.borderWidth = 4
        } else {
            self.layer.borderColor = UIColor.warmGrey.cgColor
            self.layer.borderWidth = 0
        }
    }
    
}
