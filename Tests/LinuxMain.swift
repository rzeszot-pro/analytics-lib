import XCTest
import AnalyticsTests

var tests = [XCTestCaseEntry]()

tests += CollectorTests.allTests()
tests += HardwareTests.allTests()
tests += SerializerTests.allTests()
tests += StorageTests.allTests()
tests += ContextTests.allTests()

XCTMain(tests)
