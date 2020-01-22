//
//  Context.swift
//  
//
//  Created by Damian Rzeszot on 22/01/2020.
//

import Foundation

struct Context: Encodable {
    let hardware: Hardware
    let session: UUID

    // MARK: - Encodable

    func encode(to encoder: Encoder) throws {
        try hardware.encode(to: encoder)
        try ["session": session.uuidString.lowercased()].encode(to: encoder)
    }

    // MARK: -

    static var standard: Context {
        Context(hardware: .current, session: UUID())
    }

}
