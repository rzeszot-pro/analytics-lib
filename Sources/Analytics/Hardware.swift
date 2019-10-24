//
//  File.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import UIKit

public struct Hardware {

    // MARK: -

    public static let current: Hardware = .init()

    // MARK: -

    public struct System {
        public let name: String
        public let version: String
    }

    public struct Model {
        public let code: String
    }

    public let system: System
    public let model: Model

    // MARK: -

    internal init(device: UIDevice = .current) {
        system = System(device: device)
        model = Model()
    }

}

extension Hardware.System {
    init(device: UIDevice) {
        name = device.systemName.lowercased()
        version = device.systemVersion
    }
}

extension Hardware.Model {
    init() {
        var info = utsname()
        uname(&info)

        code = withUnsafePointer(to: &info.machine) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: 1) { pointer  in
                String(cString: pointer)
            }
        }
    }
}
