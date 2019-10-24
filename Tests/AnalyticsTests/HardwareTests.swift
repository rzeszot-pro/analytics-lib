import XCTest
@testable import Analytics

final class HardwareTests: XCTestCase {

    var sut: Hardware!

    override func setUp() {
        sut = Hardware.current
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: - System

    func testSystemName() {
        XCTAssertEqual(sut.system.name, UIDevice.current.systemName.lowercased())
    }

    func testSystemVersion() {
        XCTAssertEqual(sut.system.version, UIDevice.current.systemVersion)
    }

    // MARK: - Model

    func testModelCode() {
        XCTAssertEqual(sut.model.code, "x86_64")
    }

    // MARK: -

    static var allTests = [
        ("testSystemName", testSystemName),
        ("testSystemVersion", testSystemVersion)
    ]

}
