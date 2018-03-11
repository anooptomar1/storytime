//
// Created by Akito Nozaki on 3/7/18.
// Copyright (c) 2018 Ikazone. All rights reserved.
//

import Foundation

public struct Printer {
    public enum ConnectionType {
        case wifi
        case bluetooth
    }
    
    public let model: String
    public let serialNumber: String
    public let vendor: String
    public let connectionType: ConnectionType
    public let ip: String?
    
    public var deviceName: String {
        get {
            return "\(vendor) \(model)"
        }
    }
    
    init(connectionType: ConnectionType, model: String, serialNumber: String, vendor: String = "Brother", ip: String? = nil) {
        self.connectionType = connectionType
        self.model = model
        self.serialNumber = serialNumber
        self.vendor = vendor
        self.ip = ip
    }
}
