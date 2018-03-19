//
// Created by Akito Nozaki on 3/17/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjackSwift

class ScrapBookCoordinator: NSObject, Coordinator {
    public enum Action {
        case close
    }
    
    public enum SelectionMode {
        case photo
        case camera
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
        self.showPhotoSelection(mode: .photo)
    }
    
    open func dismiss() {
        router.pop(to: topVC)
    }
}

extension ScrapBookCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showPhotoSelection(mode: SelectionMode) {
        let controller = UIImagePickerController()
        controller.delegate = self
        
        router.present(controller, animated: true) {}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        // show customization screen after image is picked...
        DDLogDebug("Selected \(info)")
    
        router.dismiss(animated: true) {}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        router.dismiss(animated: true) {}
    }
}