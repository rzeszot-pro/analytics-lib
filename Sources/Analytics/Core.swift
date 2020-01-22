//
//  Core.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation


public class Core {

    // MARK: -

    let collector: Collector
    let storage: Storage
    let serializer: Serializer
    let publisher: Publisher
    let context: Context

    // MARK: -

    init(context: Context = .standard, publisher: Publisher = .init(), collector: Collector = .init(), storage: Storage = .init(), serializer: Serializer = .init()) {
        self.context = context

        self.publisher = publisher
        self.collector = collector
        self.storage = storage
        self.serializer = serializer

        if let data = storage.load() {
            let entries = serializer.deserialize(data: data)
            collector.load(entries: entries)

            inspect("analytics | loaded \(entries.count) events")

            collector.track(type: "load", parameters: [
                "count": entries.count
            ])
        } else {
            collector.track(type: "load", parameters: [
                "count": 0
            ])
        }

        collector.track(type: "init", parameters: context)
    }

    func track(trace: String? = nil, type: String, parameters: Any?) {
        collector.track(trace: trace, type: type, parameters: parameters)

        let entries = collector.dispose()
        guard entries.count > 0 else { return }

        let data = serializer.serialize(entries: entries)
        publisher.publish(data: data)
    }

    func archive() {
        let entries = collector.store()
        let data = serializer.serialize(entries: entries)

        storage.store(data: data)

        inspect("analytics | archived \(entries.count) events")
    }

}
