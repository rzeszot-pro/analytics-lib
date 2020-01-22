//
//  Analytics.swift
//  
//
//  Created by Damian Rzeszot on 22/01/2020.
//

import Foundation

public class Analytics {

    private static let core = Core()

    public class func track(_ type: String, parameters: Any? = nil) {
        core.track(type, parameters: parameters)
    }

    public class func archive() {
        core.archive()
    }

}
