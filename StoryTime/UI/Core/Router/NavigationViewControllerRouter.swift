//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit

// Super basic navigation controller based router with no special animation.
open class NavigationControllerRouter: ViewControllerRouter {
    public init(_ controller: UINavigationController) {
        super.init(controller)
    }
    
    open override func pushVC(_ module: UIViewController?, animated: Bool) {
        guard let controller = module else { return }
        if let navigationController = rootController as? UINavigationController {
            navigationController.pushViewController(controller, animated: animated)
        } else {
            super.pushVC(module, animated: animated)
        }
    }
    
    open override func popVC(animated: Bool) {
        if let navigationController = rootController as? UINavigationController {
            navigationController.popViewController(animated: animated)
        } else {
            super.popVC(animated: animated)
        }
    }
    
    open override func popToVC(_ module: UIViewController, animated: Bool) {
        if let navigationController = rootController as? UINavigationController {
            navigationController.popToViewController(module, animated: animated)
        } else {
            super.popToVC(module, animated: animated)
        }
    }
    
    
    open override func topVC() -> UIViewController? {
        if let navigationController = rootController as? UINavigationController {
            return navigationController.topViewController
        } else {
            return rootController
        }
    }
}

