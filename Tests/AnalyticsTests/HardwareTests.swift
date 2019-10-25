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
        #if canImport(UIKit)
        XCTAssertEqual(sut.system.name, UIDevice.current.systemName.lowercased())
        #else
        XCTAssertEqual(sut.system.name, "???")
        #endif
    }

    func testSystemVersion() {
        #if canImport(UIKit)
        XCTAssertEqual(sut.system.version, UIDevice.current.systemVersion)
        #else
        XCTAssertEqual(sut.system.version, "???")
        #endif
    }

    // MARK: - Model

    func testModelCode() {
        XCTAssertEqual(sut.model.code, "x86_64")
    }

    // MARK: -

    static var allTests = [
        ("testSystemName", testSystemName),
        ("testSystemVersion", testSystemVersion),
        ("testModelCode", testModelCode)
    ]

}
