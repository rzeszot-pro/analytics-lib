//
//  Storage.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

public class Storage {

    // MARK: -

    private let path: URL

    public init(path: URL) {
        self.path = path
    }

    convenience init(manager: FileManager = .default) {
        let url = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("events")
        self.init(path: url)
    }

    // MARK: -

    public func store(data: Data) {
        print("analytics | storage | store \(path)")

        do {
            try data.write(to: path)
        } catch {
            print("analytics | storage | store error \(error) ")
        }
    }

    public func load() -> Data? {
        print("analytics | storage | load \(path)")

        do {
            return try Data(contentsOf: path)
        } catch {
            print("analytics | storage | load error \(error) ")
            return nil
        }
    }

}
