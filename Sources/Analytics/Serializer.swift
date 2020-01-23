//
//  Serializer.swift
//  
//
//  Created by Damian Rzeszot on 24/10/2019.
//

import Foundation

class Serializer {

    // MARK: -

    typealias Entry = Collector.Entry

    struct Payload: Codable {
        let entries: [Entry]
    }

    // MARK: -

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.dateEncodingStrategy = .millisecondsSince1970
        encoder.keyEncodingStrategy = .convertToSnakeCase

        decoder.dateDecodingStrategy = .millisecondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        encoder.outputFormatting = [.withoutEscapingSlashes]

        #if DEBUG
        encoder.outputFormatting = .prettyPrinted
        #endif
    }

    // MARK: -

    func serialize(entries: [Entry]) -> Data {
        let payload = Payload(entries: entries)
        return try! encoder.encode(payload)
    }

    func deserialize(data: Data) -> [Entry] {
        do {
            return try decoder.decode(Payload.self, from: data).entries
        } catch {
            return []
        }
    }

}

extension Serializer.Entry: Codable {

    private enum Key: String, CodingKey {
        case date = "d"
        case trace = "f"
        case type = "t"
        case parameters = "p"
        case index = "i"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        date = try container.decode(Date.self, forKey: .date)
        trace = try container.decodeIfPresent([String].self, forKey: .trace) ?? []
        type = try container.decode(String.self, forKey: .type)
        index = try container.decodeIfPresent(Int.self, forKey: .index) ?? -1

        if container.contains(.parameters) {
            parameters = try container.decode(AnyCodable.self, forKey: .parameters).value
        } else {
            parameters = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        try container.encode(date, forKey: .date)
        try container.encode(type, forKey: .type)
        try container.encode(index, forKey: .index)

        if !trace.isEmpty {
            try container.encode(trace, forKey: .trace)
        }

        if let parameters = parameters {
            try container.encode(AnyCodable(value: parameters), forKey: .parameters)
        }
    }

}

struct AnyCodable: Codable {
    private struct Key: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(intValue: Int) {
            self.stringValue = "Index \(intValue)"
            self.intValue = intValue
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }

    let value: Any

    init(value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: Key.self) {
            var result: [String: Any] = [:]

            for key in container.allKeys {
                result[key.stringValue] = try container.decode(AnyCodable.self, forKey: key).value
            }

            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result: [Any] = []

            while !container.isAtEnd {
                result.append(try container.decode(AnyCodable.self).value)
            }

            value = result
        } else if let container = try? decoder.singleValueContainer() {
            if let bool = try? container.decode(Bool.self) {
                value = bool
            } else if let int = try? container.decode(Int.self) {
                value = int
            } else if let double = try? container.decode(Double.self) {
                value = double
            } else if let string = try? container.decode(String.self) {
                value = string
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode value")
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown container"))
        }
    }

    func encode(to encoder: Encoder) throws {
        if let value = value as? Encodable {
            try value.encode(to: encoder)
        } else if let dictionary = value as? [String: Any] {
            var container = encoder.container(keyedBy: Key.self)

            for (key, value) in dictionary {
                try container.encode(AnyCodable(value: value), forKey: Key(stringValue: key)!)
            }
        } else if let array = value as? [Any] {
            var container = encoder.unkeyedContainer()

            for value in array {
                try container.encode(AnyCodable(value: value))
            }
        } else {
            try "non_encodable_parameters # \(type(of: value))".encode(to: encoder)
        }
    }

}
