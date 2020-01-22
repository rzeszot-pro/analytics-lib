import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CollectorTests.allTests),
        testCase(ContextTests.allTests),
        testCase(CoreTests.allTests),
        testCase(HardwareTests.allTests),
        testCase(SerializerTests.allTests),
        testCase(StorageTests.allTests)
    ]
}
#endif
