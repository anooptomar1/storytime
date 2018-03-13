//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

extension UIStoryboard {
    static var main: UIStoryboard {
        get {
            return UIStoryboard(name: "Main", bundle: Bundle(for: AppDelegate.self))
        }
    }
    
    static var sticker: UIStoryboard {
        get {
            return UIStoryboard(name: "Sticker", bundle: Bundle(for: AppDelegate.self))
        }
    }

    static var story: UIStoryboard {
        get {
            return UIStoryboard(name: "Story", bundle: Bundle(for: AppDelegate.self))
        }
    }
}