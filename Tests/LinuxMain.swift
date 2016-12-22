import XCTest
@testable import AtomicsTests
@testable import ClangAtomicsTests

XCTMain([
  testCase(ClangAtomicsTests.allTests),
  testCase(ClangAtomicsRaceTests.allTests),
  testCase(AtomicsTests.allTests),
  testCase(AtomicsRaceTests.raceTests),
])
