import XCTest
@testable import AtomicsTests
@testable import ClangAtomicsTests

XCTMain([
  testCase(ClangAtomicsTests.allTests),
  testCase(ClangAtomicsRaceTests.allTests),
  testCase(MemoryOrderTests.allTests),
  testCase(AtomicsTests.allTests),
  testCase(AtomicsPerformanceTests.allTests),
  testCase(AtomicsRaceTests.raceTests),
])
