//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit

class StoryTimeViewController<T>: UIViewController {
    var viewModel: T!
    
    open func start(with viewModel: T) {
        self.viewModel = viewModel
        bind()
    }
    
    open func bind() {
    
    }
}
