//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit

open class ViewControllerRouter: Router {
    let rootController: UIViewController
    
    public init(_ controller: UIViewController) {
        self.rootController = controller
    }
    
    open func presentVC(_ module: UIViewController?, animated: Bool, completion: (() -> Void)?) {
        guard let module = module else { return }
        rootController.present(module, animated: animated, completion: completion)
    }
    
    open func replaceVC(_ module: UIViewController?, animated: Bool, completion: (() -> Void)?) {
        rootController.dismiss(animated: animated) { [weak self] in
            self?.present(module, animated: animated, completion: completion)
        }
    }
    
    open func dismissVC(animated: Bool, completion: (() -> Void)?) {
        rootController.dismiss(animated: animated, completion: completion)
    }
    
    open func pushVC(_ module: UIViewController?, animated: Bool) {
        let fromViewController = rootController.childViewControllers.first
        if let module = module {
            rootController.addChildViewController(module)
            rootController.view.addSubview(module.view)
            
            module.view.translatesAutoresizingMaskIntoConstraints = false
            module.view.widthAnchor.constraint(equalTo: rootController.view.widthAnchor).isActive = true
            module.view.heightAnchor.constraint(equalTo: rootController.view.heightAnchor).isActive = true
            module.view.topAnchor.constraint(equalTo: rootController.view.topAnchor).isActive = true
            module.view.centerYAnchor.constraint(equalTo: rootController.view.centerYAnchor).isActive = true
            
            module.didMove(toParentViewController: rootController)
        }
        
        if let fromViewController = fromViewController {
            fromViewController.willMove(toParentViewController: nil)
            fromViewController.view.removeFromSuperview()
            fromViewController.removeFromParentViewController()
        }
    }
    
    open func popVC(animated: Bool) {
        dismissVC(animated: true, completion: nil)
    }
    
    open func popToVC(_ module: UIViewController, animated: Bool) {
        dismissVC(animated: true, completion: nil)
    }
    
    open func topVC() -> UIViewController? {
        return rootController
    }
}
