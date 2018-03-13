//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift

class StoryTimeViewController<T>: UIViewController {
    var viewModel: T!
    
    deinit {
        DDLogDebug("DEINIT: \(type(of: self))")
    }
    
    open func start(with viewModel: T) {
        self.viewModel = viewModel
        bind()
    }
    
    open func bind() {
    
    }
}
