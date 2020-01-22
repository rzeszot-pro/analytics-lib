//
//  Trace.swift
//  
//
//  Created by Damian Rzeszot on 22/01/2020.
//

import Foundation

public class Trace {

    private let name: String
    private let core: Core

    init(name: String, core: Core) {
        self.name = name
        self.core = core
    }

    // MARK: -

    public func track(_ type: String, parameters: Any? = nil) {
        core.track(trace: name, type: type, parameters: parameters)
    }

}
