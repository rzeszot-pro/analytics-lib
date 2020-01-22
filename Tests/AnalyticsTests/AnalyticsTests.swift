import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {

    var sut: Analytics!

    override func setUp() {
        let context = Context(hardware: .test, session: .test)

        sut = Analytics(context: context, storage: Storage(path: URL(string: "/tmp/events")!))
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: -

    func testInitialEntries() {
        let entries = sut.collector.entries

        XCTAssertEqual(entries.count, 2)

        XCTAssertEqual(entries[0].type, "load")
        XCTAssertEqual((entries[0].parameters as? [String:Int])?["count"], 0)

        XCTAssertEqual(entries[1].type, "init")
    }

    // MARK: -

    static var allTests = [
        ("testInitialEntries", testInitialEntries)
    ]

}

private extension Hardware {
    static var test: Hardware {
        Hardware(system: .init(name: "ios", version: "13.0"), model: .init(code: "simulator"))
    }
}

private extension UUID {
    static var test: UUID {
        UUID(uuidString: "01234567-89AB-CDEF-0123-456789ABCDEF")!
    }
}
