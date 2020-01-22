import XCTest
@testable import Analytics

final class ContextTests: XCTestCase {

    func testSerializeContext() {
        let hardware = Hardware(system: .init(name: "ios", version: "13.0"), model: .init(code: "simulator"))
        let context = Context(hardware: hardware, session: UUID(uuidString: "01234567-89AB-CDEF-0123-456789ABCDEF")!)

        let serializer = Serializer()
        serializer.now = .now

        let entry = Serializer.Entry(date: .now, type: "init", index: 0, parameters: context)

        let data = serializer.serialize(entries: [entry])

        let result = """
            {
              "date" : 100000,
              "entries" : [
                {
                  "d" : 100000,
                  "i" : 0,
                  "p" : {
                    "system" : {
                      "name" : "ios",
                      "version" : "13.0"
                    },
                    "model" : {
                      "code" : "simulator"
                    },
                    "session" : "01234567-89ab-cdef-0123-456789abcdef"
                  },
                  "t" : "init"
                }
              ]
            }
            """

        XCTAssertEqual(String(data: data, encoding: .utf8)!, result)
    }

    // MARK: -

    static var allTests = [
        ("testSerializeContext", testSerializeContext)
    ]

}

private extension Date {
    static var now: Date = .init(timeIntervalSince1970: 100)
}
