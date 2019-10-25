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
        let entry = Entry(date: .now, type: "test", parameters: nil)
        let data = sut.serialize(entries: [entry])

        let result = """
            [
              {
                "d" : 100000,
                "t" : "test"
              }
            ]
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersInt() {
        let entry = Entry(date: .now, type: "test", parameters: 123)
        let data = sut.serialize(entries: [entry])

        let result = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : 123
              }
            ]
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersString() {
        let entry = Entry(date: .now, type: "test", parameters: "string")
        let data = sut.serialize(entries: [entry])

        let result = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : "string"
              }
            ]
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersBool() {
        let entry = Entry(date: .now, type: "test", parameters: true)
        let data = sut.serialize(entries: [entry])

        let result = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : true
              }
            ]
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersDictionary() {
        let entry = Entry(date: .now, type: "test", parameters: ["dict": "yes"])
        let data = sut.serialize(entries: [entry])

        let result = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : {
                  "dict" : "yes"
                }
              }
            ]
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    func testSerializeParametersCustom() {
        struct Custom: Codable {
            let string: String
            let bool: Bool
        }

        let entry = Entry(date: .now, type: "test", parameters: Custom(string: "string", bool: false))
        let data = sut.serialize(entries: [entry])

        let result = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : {
                  "string" : "string",
                  "bool" : false
                }
              }
            ]
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    // MARK: - Deserialize

    func testDeserializeType() {
        let input = """
            [
              {
                "d" : 100000,
                "t" : "test"
              }
            ]
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertNil(entry.parameters)
    }

    func testDeserializeParametersInt() {
        let input = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : 123
              }
            ]
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.parameters as? Int, 123)
    }

    func testDeserializeParametersString() {
        let input = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : "string"
              }
            ]
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.parameters as? String, "string")
    }

    func testDeserializeParametersBool() {
        let input = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : false
              }
            ]
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.parameters as? Bool, false)
    }

    func testDeserializeParametersDictionary() {
        let input = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : {
                  "dict" : "yes"
                }
              }
            ]
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
        XCTAssertEqual(entry.parameters as? [String: String], ["dict": "yes"])
    }

    func testDeserializeParametersCustom() {
        struct Custom: Codable {
            let string: String
            let bool: Bool
        }

        let input = """
            [
              {
                "d" : 100000,
                "t" : "test",
                "p" : {
                  "string" : "string",
                  "bool" : false
                }
              }
            ]
            """

        let entry = sut.deserialize(data: input.data(using: .utf8)!)[0]

        XCTAssertEqual(entry.date, Date.now)
        XCTAssertEqual(entry.type, "test")
//        XCTAssertEqual(entry.parameters as? [String: Any], ["string": "string", "bool": false])
    }

    // MARK: -

    static var allTests = [
        ("testSerializeType", testSerializeType)
    ]

}

extension Date {
    static var now: Date = .init(timeIntervalSince1970: 100)
}
