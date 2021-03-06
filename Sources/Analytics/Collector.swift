//
//  Collector.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

class Collector {

    // MARK: -

    var limit: Int = 10

    // MARK: -

    struct Entry {
        let date: Date
        let trace: [String]
        let type: String
        let index: Int
        let parameters: Any?
    }

    private(set) var entries: [Entry] = []

    var count: Int {
        entries.count
    }

    // MARK: -

    func track(trace: [String] = [], type: String, parameters: Any? = nil) {
        let entry = Entry(date: Date(), trace: trace, type: type, index: count, parameters: parameters)

        inspect("analytics | collector | track \(trace.joined(separator: ".")).\(type)")

        entries.append(entry)
    }

    func dispose() -> [Entry] {
        guard count >= limit else { return [] }

        let slice = entries.prefix(limit)
        entries.removeFirst(slice.count)
        return Array(slice)
    }

    // MARK: -

    func store() -> [Entry] {
        entries
    }

    func load(entries: [Entry]) {
        self.entries = entries
    }

}
