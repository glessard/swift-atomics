import XCTest
import AtomicsTests
import CAtomicsTests

XCTMain([
  testCase(MemoryOrderTests.allTests),
  testCase(CAtomicsTests.allTests),
  testCase(CAtomicsRaceTests.allTests),
  testCase(AtomicsTests.allTests),
  testCase(AtomicsRaceTests.raceTests),
])
