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
        var date: Date
        let type: String
        let parameters: [String: Any]
    }

    internal private(set) var entries: [Entry] = []

    public var count: Int {
        entries.count
    }

    // MARK: -

    public func track(_ type: String, parameters: [String: Any] = [:]) {
        let entry = Entry(date: .init(), type: type, parameters: parameters)

        print("analytics | collector | track \(type)")

        entries.append(entry)
    }

    internal func dispose() -> [Entry] {
        guard count >= limit else { return [] }

        let slice = entries.prefix(limit)
        entries.removeFirst(slice.count)
        return Array(slice)
    }

    // MARK: -

    internal func store() -> [Entry] {
        entries
    }

    func load(entries: [Entry]) {
        self.entries = entries
    }

}
