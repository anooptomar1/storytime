//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

class StickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedView: UIImageView!
    
    public func update(for item: StickerItemViewModel) {
        imageView.image = item.sticker.coverImage
        // selectedView.isHidden = !item.selected
    }
    
}
