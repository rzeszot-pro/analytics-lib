import XCTest
import AnalyticsTests

var tests = [XCTestCaseEntry]()

tests += AnalyticsTests.allTests()
tests += CollectorTests.allTests()
tests += ContextTests.allTests()
tests += HardwareTests.allTests()
tests += SerializerTests.allTests()
tests += StorageTests.allTests()

XCTMain(tests)
