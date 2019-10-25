import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CollectorTests.allTests),
        testCase(HardwareTests.allTests),
        testCase(SerializerTests.allTests)
    ]
}
#endif
