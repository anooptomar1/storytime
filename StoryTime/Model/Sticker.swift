//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import SceneKit

public struct Sticker {
    // cover photo.
    let coverImage: UIImage
    
    // actual image that will be printed out on sticker.
    let referenceImage: UIImage

    // For demo, we will just have all the 3d asset in the app. No reason to do anything more fancier then this.
    let assetKey: String
    
    var node: SCNNode?
}
