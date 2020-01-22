import XCTest
@testable import Analytics

final class TraceTests: XCTestCase {

    var sut: Trace!
    var core: Core!

    override func setUp() {
        let context = Context(hardware: .test, session: .test)
        core = Core(context: context, storage: Storage(path: URL(string: "/tmp/events")!))

        sut = Trace(name: "sample", core: core)
    }

    override func tearDown() {
        sut = nil
        core = nil
    }

    // MARK: -

    func testTrace() {
        sut.track("first")
        sut.track("second", parameters: ["some": "value"])

        let entries = core.collector.entries

        XCTAssertEqual(entries.count, 4)

        XCTAssertEqual(entries[2].trace, "sample")
        XCTAssertEqual(entries[2].type, "first")

        XCTAssertEqual(entries[3].trace, "sample")
        XCTAssertEqual(entries[3].type, "second")
    }

    // MARK: -

    static var allTests = [
        ("testTrace", testTrace)
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
