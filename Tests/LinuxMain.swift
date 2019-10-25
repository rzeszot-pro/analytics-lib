import XCTest
import AnalyticsTests

var tests = [XCTestCaseEntry]()

tests += CollectorTests.allTests()
tests += HardwareTests.allTests()
tests += SerializerTests.allTests()
tests += StorageTests.allTests()

XCTMain(tests)
