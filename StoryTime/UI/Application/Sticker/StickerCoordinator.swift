//
// Created by Akito Nozaki on 3/11/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

class StickerCoordinator: Coordinator {
    private let router: Router
    private weak var topVC: UIViewController! = nil
    
    public var child: [Coordinator] = []
    
    public init(router: Router) {
        self.router = router
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
        
        controller.start(with: model)
        self.router.push(controller)
    }
}