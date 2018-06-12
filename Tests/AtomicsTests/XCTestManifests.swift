import XCTest

extension AtomicsBasicTests {
    static let __allTests = [
        ("testBool", testBool),
        ("testFence", testFence),
        ("testInt", testInt),
        ("testInt16", testInt16),
        ("testInt32", testInt32),
        ("testInt64", testInt64),
        ("testInt8", testInt8),
        ("testOpaquePointer", testOpaquePointer),
        ("testUInt", testUInt),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testUInt8", testUInt8),
        ("testUnmanaged", testUnmanaged),
        ("testUnsafeMutablePointer", testUnsafeMutablePointer),
        ("testUnsafeMutableRawPointer", testUnsafeMutableRawPointer),
        ("testUnsafePointer", testUnsafePointer),
        ("testUnsafeRawPointer", testUnsafeRawPointer),
    ]
}

extension AtomicsRaceTests {
    static let __allTests = [
        ("testRaceCrash", testRaceCrash),
        ("testRacePointerCAS", testRacePointerCAS),
        ("testRacePointerLoadCAS", testRacePointerLoadCAS),
        ("testRacePointerSwap", testRacePointerSwap),
        ("testRaceSpinLock", testRaceSpinLock),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AtomicsBasicTests.__allTests),
        testCase(AtomicsRaceTests.__allTests),
    ]
}
#endif
