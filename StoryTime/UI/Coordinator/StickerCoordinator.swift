//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjackSwift

class StickerCoordinator: Coordinator {
    public enum Action {
        case close
    }
    
    private let _action = PublishSubject<Action>()
    public var action: Observable<Action> {
        get {
            return _action.asObservable()
        }
    }
    
    
    private let router: Router
    private weak var topVC: UIViewController! = nil
    private var disposeBag: DisposeBag! = nil
    
    public var child: [Coordinator] = []
    
    public init(router: Router) {
        self.router = router
    }
    
    deinit {
        DDLogDebug("DEINIT: \(type(of: self))")
    }
    
    open func start() {
        topVC = router.top()
        self.showSticker()
    }
    
    open func dismiss() {
        router.pop(to: topVC)
    }
}

extension StickerCoordinator {
    func showSticker() {
        let controller = UIStoryboard.sticker.instantiateViewController(withIdentifier: "StickerViewController") as! StickerViewController
        let model = StickerViewModel()
        disposeBag = DisposeBag()
        
        controller.start(with: model)
        model.action
            .do(
                onSubscribe: { [weak self] in self?.router.push(controller) },
                onDispose: { [weak self] in self?.router.pop() }
            )
            .subscribe(onNext: { [weak self] action in
                switch action {
                    case .close:
                        self?.disposeBag = nil
                        self?._action.onNext(.close)
                }
                
            })
            .disposed(by: disposeBag)
    }
}