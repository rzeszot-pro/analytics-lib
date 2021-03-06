//
//  Storage.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

class Storage {

    // MARK: -

    private let path: URL

    // MARK: - Initialization

    init(path: URL) {
        self.path = path
    }

    convenience init(manager: FileManager = .default) {
        let url = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("events")
        self.init(path: url)
    }

    // MARK: -

    func store(data: Data) {
        inspect("analytics | storage | store")

        do {
            try data.write(to: path)
        } catch {
            inspect("analytics | storage | store error \(error) ")
        }
    }

    func load() -> Data? {
        inspect("analytics | storage | load")

        do {
            return try Data(contentsOf: path)
        } catch {
            if (error as NSError).domain == NSCocoaErrorDomain, (error as NSError).code == 260 {
                inspect("analytics | storage | load error - nothing to load")
            } else {
                inspect("analytics | storage | load error \(error) ")
            }

            return nil
        }
    }

}
