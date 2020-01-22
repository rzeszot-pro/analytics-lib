//
//  Analytics.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation


public class Analytics {

    public class func track(_ type: String, parameters: Any? = nil) {
        shared.track(type, parameters: parameters)
    }

    public class func archive() {
        shared.archive()
    }

    // MARK: -

    private static let shared = Analytics()

    // MARK: -

    let collector = Collector()
    let storage = Storage()
    let serializer = Serializer()

    let publisher: Publisher
    let context: Context

    // MARK: -

    init(context: Context = .standard) {
        self.context = context
        self.publisher = Publisher(session: context.session)

        collector.track("init", parameters: context)

        if let data = storage.load() {
            let entries = serializer.deserialize(data: data)
            collector.load(entries: entries)

            inspect("analytics | loaded \(entries.count) events")
        }

        collector.track("load", parameters: [
            "count": collector.entries.count
        ])
    }

    func track(_ type: String, parameters: Any?) {
        collector.track(type, parameters: parameters)

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
