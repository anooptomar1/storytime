//
// Created by Akito Nozaki on 3/17/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjackSwift

class ScrapBookViewModel: ViewModelCore {
    public enum Action {
        case close
        case cameraMode
        case photoMode
    }
    
    private var selectedImage: UIImage?
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    public func onSelectPhoto(selection: UIImage) {
    
    }
    
    public func onSelectEffect(/*effect information*/) {
    
    }
    
}
