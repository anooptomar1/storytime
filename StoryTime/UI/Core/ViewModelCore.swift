//
// Created by Akito Nozaki on 3/12/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift

open class ViewModelCore: ViewModel {
    deinit {
        DDLogDebug("DEINIT: \(type(of: self))")
    }
}
