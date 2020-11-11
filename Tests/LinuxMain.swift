import XCTest

import SamplePkg2Tests

var tests = [XCTestCaseEntry]()
tests += SamplePkg2Tests.allTests()
XCTMain(tests)
