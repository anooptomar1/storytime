//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
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

extension MainCoordinator {
    func showDashboard() {
        let controller = UIStoryboard.main.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        let model = DashboardViewModel()
        
        controller.start(with: model)
        _ = model.action.subscribe(
            onNext: { [weak self] action in
                switch action {
                    case .onAr: self?.runAr()
                }
            })
        // model.action.subscribe ...
        
        self.router.push(controller)
    }
    
    func runAr() {
        let coordinator = ArCoordinator(router: self.router)
//        coordinator.action
//            .do(onSubscribe: { [weak self] in self?.add(coordinator) })
//            .do(onDispose: { [weak self] in self?.remove(coordinator) })
//            .subscribe(onNext: { [weak self] action in
//                switch action {
//                    case .logout:
//                        self?.popoverBag = nil
//                        self?._action.on(.next(.logout))
//                    default:
//                        break
//                }
//            })
        self.add(coordinator)
        
        coordinator.start()
    }
}