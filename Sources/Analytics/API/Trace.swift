//
//  Trace.swift
//  
//
//  Created by Damian Rzeszot on 22/01/2020.
//

import Foundation

public class Trace {

    private let path: [String]
    private let core: Core

    init(path: [String], core: Core) {
        self.path = path
        self.core = core
    }

    // MARK: -

    public func track(_ type: String, parameters: Any? = nil) {
        core.track(trace: path, type: type, parameters: parameters)
    }

    public func trace(_ name: String) -> Trace {
        Trace(path: path + [name], core: core)
    }

}
