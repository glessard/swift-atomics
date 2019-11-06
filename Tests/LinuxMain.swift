import XCTest

import CAtomicsTests
import SwiftAtomicsTests

var tests = [XCTestCaseEntry]()
tests += CAtomicsTests.__allTests()
tests += SwiftAtomicsTests.__allTests()

XCTMain(tests)
