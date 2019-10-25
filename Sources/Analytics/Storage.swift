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
            inspect("analytics | storage | load error \(error) ")
            return nil
        }
    }

}
