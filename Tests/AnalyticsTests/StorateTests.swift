import XCTest
@testable import Analytics

final class StorateTests: XCTestCase {

    var sut: Storage!

    override func setUp() {
        sut = Storage()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: -

    func testExample() {

    }

    // MARK: -
    static var allTests = [
        ("testExample", testExample),
    ]

}
