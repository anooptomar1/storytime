//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

public struct Printer {
    public let model: String
    public let serialNumber: String
    public let vendor: String
    
    public var deviceName: String {
        get {
            return "\(vendor) \(model)"
        }
    }
    
    init(model: String, serialNumber: String, vendor: String = "Brother") {
        self.model = model
        self.serialNumber = serialNumber
        self.vendor = vendor
    }
}
