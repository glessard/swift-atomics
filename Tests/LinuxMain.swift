import XCTest

import SwiftAtomicsTests
import CAtomicsTests

var tests = [XCTestCaseEntry]()
tests += SwiftAtomicsTests.__allTests()
tests += CAtomicsTests.__allTests()

XCTMain(tests)
