//
//  File.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

struct Hardware {

    // MARK: -

    static let current: Hardware = .init()

    // MARK: -

    struct System {
        public let name: String
        public let version: String
    }

    struct Model {
        public let code: String
    }

    let system: System
    let model: Model

    // MARK: -

    internal init() {
        system = System()
        model = Model()
    }

}

extension Hardware.System {
    #if canImport(UIKit)
    init(device: UIDevice = .current) {
        name = device.systemName.lowercased()
        version = device.systemVersion
    }
    #else
    init() {
        name = "???"
        version = "???"
    }
    #endif
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
