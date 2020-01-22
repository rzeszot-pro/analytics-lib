import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnalyticsTests.allTests),
        testCase(CollectorTests.allTests),
        testCase(ContextTests.allTests),
        testCase(HardwareTests.allTests),
        testCase(SerializerTests.allTests),
        testCase(StorageTests.allTests)
    ]
}
#endif
