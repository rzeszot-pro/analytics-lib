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
    let publisher = Publisher()
    let hardware = Hardware.current

    // MARK: -

    init() {
        guard let data = storage.load() else { return }

        collector.track("init", parameters: [
            "model": hardware.model.code,
            "system": hardware.system.name + "_" + hardware.system.version
        ])

        let entries = serializer.deserialize(data: data)
        collector.load(entries: entries)

        #if DEBUG
        print("analytics | loaded \(entries.count) events")
        #endif
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

        #if DEBUG
        print("analytics | archived \(entries.count) events")
        #endif
    }

}
