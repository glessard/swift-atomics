import XCTest

extension CAtomicsBasicTests {
    static let __allTests = [
        ("testAtomicNonNullMutableRawPointer", testAtomicNonNullMutableRawPointer),
        ("testAtomicNonNullOpaquePointer", testAtomicNonNullOpaquePointer),
        ("testAtomicNonNullRawPointer", testAtomicNonNullRawPointer),
        ("testAtomicOptionalMutableRawPointer", testAtomicOptionalMutableRawPointer),
        ("testAtomicOptionalOpaquePointer", testAtomicOptionalOpaquePointer),
        ("testAtomicOptionalRawPointer", testAtomicOptionalRawPointer),
        ("testAtomicPaddedMutableRawPointer", testAtomicPaddedMutableRawPointer),
        ("testAtomicPaddedOptionalMutableRawPointer", testAtomicPaddedOptionalMutableRawPointer),
        ("testAtomicPaddedOptionalRawPointer", testAtomicPaddedOptionalRawPointer),
        ("testAtomicPaddedRawPointer", testAtomicPaddedRawPointer),
        ("testAtomicPaddedTaggedMutableRawPointer", testAtomicPaddedTaggedMutableRawPointer),
        ("testAtomicPaddedTaggedOptionalMutableRawPointer", testAtomicPaddedTaggedOptionalMutableRawPointer),
        ("testAtomicPaddedTaggedOptionalRawPointer", testAtomicPaddedTaggedOptionalRawPointer),
        ("testAtomicPaddedTaggedRawPointer", testAtomicPaddedTaggedRawPointer),
        ("testAtomicTaggedMutableRawPointer", testAtomicTaggedMutableRawPointer),
        ("testAtomicTaggedOptionalMutableRawPointer", testAtomicTaggedOptionalMutableRawPointer),
        ("testAtomicTaggedOptionalRawPointer", testAtomicTaggedOptionalRawPointer),
        ("testAtomicTaggedRawPointer", testAtomicTaggedRawPointer),
        ("testBool", testBool),
        ("testFence", testFence),
        ("testInt", testInt),
        ("testInt16", testInt16),
        ("testInt32", testInt32),
        ("testInt64", testInt64),
        ("testInt8", testInt8),
        ("testPaddedPointers", testPaddedPointers),
        ("testTaggedMutableRawPointer", testTaggedMutableRawPointer),
        ("testTaggedOptionalMutableRawPointer", testTaggedOptionalMutableRawPointer),
        ("testTaggedOptionalRawPointer", testTaggedOptionalRawPointer),
        ("testTaggedRawPointer", testTaggedRawPointer),
        ("testUInt", testUInt),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testUInt8", testUInt8),
    ]
}

extension CAtomicsRaceTests {
    static let __allTests = [
        ("testRaceCrash", testRaceCrash),
        ("testRacePointerCAS", testRacePointerCAS),
        ("testRacePointerSwap", testRacePointerSwap),
        ("testRaceSpinLock", testRaceSpinLock),
        ("testRaceTaggedPointerCAS", testRaceTaggedPointerCAS),
    ]
}

extension MemoryOrderTests {
    static let __allTests = [
        ("testMemoryOrder", testMemoryOrder),
    ]
}

extension UnmanagedRaceTests {
    static let __allTests = [
        ("testRaceAtomickishUnmanaged", testRaceAtomickishUnmanaged),
    ]
}

extension UnmanagedTests {
    static let __allTests = [
        ("testCasBlocked", testCasBlocked),
        ("testDemonstrateWhyLockIsNecessary", testDemonstrateWhyLockIsNecessary),
        ("testSafeStoreFailure", testSafeStoreFailure),
        ("testSafeStoreSuccess", testSafeStoreSuccess),
        ("testSpinLoad", testSpinLoad),
        ("testSpinSwap", testSpinSwap),
        ("testSpinTake", testSpinTake),
        ("testUnmanaged", testUnmanaged),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CAtomicsBasicTests.__allTests),
        testCase(CAtomicsRaceTests.__allTests),
        testCase(MemoryOrderTests.__allTests),
        testCase(UnmanagedRaceTests.__allTests),
        testCase(UnmanagedTests.__allTests),
    ]
}
#endif
