import XCTest
import AtomicsTests
import ClangAtomicsTests

XCTMain([
  testCase(ClangAtomicsTests.allTests),
  testCase(ClangAtomicsRaceTests.allTests),
  testCase(MemoryOrderTests.allTests),
  testCase(AtomicsTests.allTests),
  testCase(AtomicsRaceTests.raceTests),
])
