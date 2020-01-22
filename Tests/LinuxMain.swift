import XCTest
import AnalyticsTests

var tests = [XCTestCaseEntry]()

tests += CollectorTests.allTests()
tests += ContextTests.allTests()
tests += CoreTests.allTests()
tests += HardwareTests.allTests()
tests += SerializerTests.allTests()
tests += StorageTests.allTests()
tests += TraceTests.allTests()

XCTMain(tests)
