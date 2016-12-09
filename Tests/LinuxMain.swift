import XCTest
@testable import AtomicsTests

XCTMain([
     testCase(AtomicsTests.allTests),
     testCase(AtomicsRaceTests.raceTests),
])
