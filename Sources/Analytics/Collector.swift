//
//  File.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

public class Collector {

    // MARK: -

    public var limit: Int = 10

    // MARK: -

    struct Entry {
        let date: Date = .init()
        let type: String
        let parameters: [String: Any]
    }

    internal private(set) var entries: [Entry] = []

    public var count: Int {
        entries.count
    }

    // MARK: -

    public func track(_ type: String, parameters: [String: Any] = [:]) {
        let entry = Entry(type: type, parameters: parameters)
        entries.append(entry)
    }

    internal func dispose() -> [Entry] {
        let slice = entries.prefix(upTo: limit)
        entries.removeFirst(slice.count)
        return Array(slice)
    }

}
