import XCTest
@testable import Analytics

final class AnalyticsTests: XCTestCase {

    var sut: Analytics!

    override func setUp() {
        sut = Analytics()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: -

    func test() {

    }

    // MARK: -

    static var allTests = [
        ("test", test)
    ]

}
