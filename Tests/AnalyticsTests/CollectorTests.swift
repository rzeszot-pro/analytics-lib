import XCTest
@testable import Analytics

final class CollectorTests: XCTestCase {

    var sut: Collector!

    override func setUp() {
        sut = Collector()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: -

    func testDefaultLimit() {
        XCTAssertEqual(sut.limit, 10)
    }

    func testEmptyQueue() {
        XCTAssertEqual(sut.count, 0)
    }

    func testTrack() {
        sut.track("example")

        XCTAssertEqual(sut.count, 1)
    }

    // MARK: -

    func testDispose() {
        sut.limit = 3

        sut.track("example", times: 5)

        XCTAssertEqual(sut.dispose().count, 3)
        XCTAssertEqual(sut.dispose().count, 0)
    }

    // MARK: -

    static var allTests = [
        ("testDefaultLimit", testDefaultLimit),
        ("testEmptyQueue", testEmptyQueue),
        ("testTrack", testTrack),
        ("testDispose", testDispose)
    ]

}

private extension Collector {
    func track(_ type: String, parameters: Codable? = nil, times: Int) {
        precondition(times > 0)

        for _ in 0..<times {
            track(type, parameters: parameters)
        }
    }
}
