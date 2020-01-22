import XCTest
@testable import Analytics

final class SerializerTests: XCTestCase {

    typealias Entry = Serializer.Entry

    var sut: Serializer!

    override func setUp() {
        sut = Serializer()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: - Serialize

    func testSerializeType() {
        let entry = Entry(date: .now, trace: nil, type: "test", index: 0, parameters: nil)
        let data = sut.serialize(entries: [entry])

        let result = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 0
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersInt() {
        let entry = Entry(date: .now, trace: nil, type: "test", index: 1, parameters: 123)
        let data = sut.serialize(entries: [entry])

        let result = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "i" : 1,
                  "p" : 123,
                  "t" : "test"
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersString() {
        let entry = Entry(date: .now, trace: nil, type: "test", index: 2, parameters: "string")
        let data = sut.serialize(entries: [entry])

        let result = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "i" : 2,
                  "p" : "string",
                  "t" : "test"
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersBool() {
        let entry = Entry(date: .now, trace: nil, type: "test", index: 3, parameters: true)
        let data = sut.serialize(entries: [entry])

        let result = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "i" : 3,
                  "p" : true,
                  "t" : "test"
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersDictionary() {
        let entry = Entry(date: .now, trace: nil, type: "test", index: 4, parameters: ["dict": "yes"])
        let data = sut.serialize(entries: [entry])

        let result = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "i" : 4,
                  "p" : {
                    "dict" : "yes"
                  },
                  "t" : "test"
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersCustom() {
        struct Custom: Codable {
            let string: String
            let bool: Bool
        }

        let entry = Entry(date: .now, trace: nil, type: "test", index: 5, parameters: Custom(string: "string", bool: false))
        let data = sut.serialize(entries: [entry])

        let result = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "i" : 5,
                  "p" : {
                    "string" : "string",
                    "bool" : false
                  },
                  "t" : "test"
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    // MARK: - Deserialize

    func testDeserializeType() {
        let input = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 0
                }
              ]
            }
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.index, 0)
        XCTAssertNil(entry.parameters)
    }

    func testDeserializeParametersInt() {
        let input = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 1,
                  "p" : 123
                }
              ]
            }
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.index, 1)
        XCTAssertEqual(entry.parameters as? Int, 123)
    }

    func testDeserializeParametersString() {
        let input = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 2,
                  "p" : "string"
                }
              ]
            }
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.index, 2)
        XCTAssertEqual(entry.parameters as? String, "string")
    }

    func testDeserializeParametersBool() {
        let input = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 3,
                  "p" : false
                }
              ]
            }
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.index, 3)
        XCTAssertEqual(entry.parameters as? Bool, false)
    }

    func testDeserializeParametersDictionary() {
        let input = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 4,
                  "p" : {
                    "dict" : "yes"
                  }
                }
              ]
            }
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.index, 4)
        XCTAssertEqual(entry.parameters as? [String: String], ["dict": "yes"])
    }

    func testDeserializeParametersCustom() {
        struct Custom: Codable {
            let string: String
            let bool: Bool
        }

        let input = """
            {
              "entries" : [
                {
                  "d" : 100000,
                  "t" : "test",
                  "i" : 5,
                  "p" : {
                    "string" : "string",
                    "bool" : false
                  }
                }
              ]
            }
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.index, 5)
        XCTAssertEqual((entry.parameters as? [String: Any])?["bool"] as? Bool, false)
        XCTAssertEqual((entry.parameters as? [String: Any])?["string"] as? String, "string")
    }

    // MARK: -

    static var allTests = [
        ("testSerializeType", testSerializeType),
        ("testSerializeParametersInt", testSerializeParametersInt),
        ("testSerializeParametersString", testSerializeParametersString),
        ("testSerializeParametersBool", testSerializeParametersBool),
        ("testSerializeParametersDictionary", testSerializeParametersDictionary),
        ("testSerializeParametersCustom", testSerializeParametersCustom),
        ("testDeserializeType", testDeserializeType),
        ("testDeserializeParametersInt", testDeserializeParametersInt),
        ("testDeserializeParametersString", testDeserializeParametersString),
        ("testDeserializeParametersBool", testDeserializeParametersBool),
        ("testDeserializeParametersDictionary", testDeserializeParametersDictionary),
        ("testDeserializeParametersCustom", testDeserializeParametersCustom)
    ]

}

private extension Date {
    static var now: Date = .init(timeIntervalSince1970: 100)
}
