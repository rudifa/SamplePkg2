import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SamplePkg2Tests.allTests),
    ]
}
#endif
