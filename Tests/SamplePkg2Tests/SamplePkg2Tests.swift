import XCTest
@testable import SamplePkg2

final class SamplePkg2Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SamplePkg2().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
