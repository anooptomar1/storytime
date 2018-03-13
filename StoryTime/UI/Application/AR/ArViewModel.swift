//
// Created by Akito Nozaki on 3/12/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift

class ArViewModel: ViewModelCore {
    public enum Action {
        case close
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    func onClose() {
        _action.onNext(.close)
    }
}
