//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

/*
 * Coordinator's job is to manage the flow of all UIViewController.
 */
public protocol Coordinator: class {
    
    var child: [Coordinator] { get set }
    
    func start()
    
    func dismiss()
}

extension Coordinator {
    func add(_ coordinator: Coordinator) {
        let isChild = child.contains { sub in sub === coordinator }
        guard !isChild else { return }
        
        child.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        coordinator.dismiss()
        child = child.filter { sub in sub !== coordinator }
    }
}
