//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

/**
 * UICollectionViewFlowLayout that wil auto size based on number of time.
 */
class StickerGridFlowLayout: UICollectionViewFlowLayout {
    public static let itemHeight = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 100
    public static let itemMinWidth = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 100
    
    override var itemSize: CGSize {
        get {
            let frame = UIEdgeInsetsInsetRect(collectionView?.frame ?? CGRect.zero, sectionInset)
            
            let numberOfItem = Int(frame.width) / (StickerGridFlowLayout.itemMinWidth + Int(minimumInteritemSpacing))
            let maxItemWidth = (frame.width / CGFloat(numberOfItem)) - 1
            
            return CGSize(width: maxItemWidth, height: CGFloat(StickerGridFlowLayout.itemHeight))
        }
        set {
            fatalError("setting itemSize is not supported for CVSSwitchingGridFlowLayout")
        }
    }
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        
        sectionInset = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
        
        scrollDirection = .vertical
    }
    
}
