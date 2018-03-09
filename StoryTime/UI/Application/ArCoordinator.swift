//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

class ArCoordinator: Coordinator {
    private let router: Router
    private weak var topVC: UIViewController! = nil
    
    public var child: [Coordinator] = []
    
    public init(router: Router) {
        self.router = router
    }
    
    open func start() {
        topVC = router.top()
        self.showDashboard()
    }
    
    open func dismiss() {
        router.pop(to: topVC)
    }
}

extension ArCoordinator {
    func showDashboard() {
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "ArViewController") as! ArViewController
        let model = DashboardViewModel()
        
        controller.start(with: model)
        
        // model.action.subscribe ...
        
        self.router.push(controller)
    }
}