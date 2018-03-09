//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import UIKit

public protocol Router {
    
    func presentVC(_ module: UIViewController?, animated: Bool, completion: (() -> Void)?)
    func replaceVC(_ module: UIViewController?, animated: Bool, completion: (() -> Void)?)
    func dismissVC(animated: Bool, completion: (() -> Void)?)
    
    func pushVC(_ module: UIViewController?, animated: Bool)
    func popVC(animated: Bool)
    func popToVC(_ module: UIViewController, animated: Bool)
    
    func topVC() -> UIViewController?
}

extension Router {
    func present(_ module: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        presentVC(module, animated: animated, completion: completion)
    }
    
    func replace(_ module: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        replaceVC(module, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismissVC(animated: animated,  completion: completion)
    }
    
    func push(_ module: UIViewController?, animated: Bool = true) {
        pushVC(module, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        popVC(animated: animated)
    }
    
    func pop(to module: UIViewController, animated: Bool = true) {
        popToVC(module, animated: animated)
    }
    
    func top() -> UIViewController? {
        return topVC()
    }
    
}
