import XCTest

import AtomicsTests
import CAtomicsTests

var tests = [XCTestCaseEntry]()
tests += AtomicsTests.__allTests()
tests += CAtomicsTests.__allTests()

XCTMain(tests)
