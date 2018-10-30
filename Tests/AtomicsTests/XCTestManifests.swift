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
        ("testNonNullOpaquePointer", testNonNullOpaquePointer),
        ("testNonNullUnsafeMutablePointer", testNonNullUnsafeMutablePointer),
        ("testNonNullUnsafeMutableRawPointer", testNonNullUnsafeMutableRawPointer),
        ("testNonNullUnsafePointer", testNonNullUnsafePointer),
        ("testNonNullUnsafeRawPointer", testNonNullUnsafeRawPointer),
        ("testOptionalOpaquePointer", testOptionalOpaquePointer),
        ("testOptionalUnsafeMutablePointer", testOptionalUnsafeMutablePointer),
        ("testOptionalUnsafeMutableRawPointer", testOptionalUnsafeMutableRawPointer),
        ("testOptionalUnsafePointer", testOptionalUnsafePointer),
        ("testOptionalUnsafeRawPointer", testOptionalUnsafeRawPointer),
        ("testUInt", testUInt),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testUInt8", testUInt8),
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

extension ReferenceRaceTests {
    static let __allTests = [
        ("testRaceAtomicReference", testRaceAtomicReference),
    ]
}

extension ReferenceTests {
    static let __allTests = [
        ("testUnmanaged", testUnmanaged),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AtomicsBasicTests.__allTests),
        testCase(AtomicsRaceTests.__allTests),
        testCase(ReferenceRaceTests.__allTests),
        testCase(ReferenceTests.__allTests),
    ]
}
#endif
