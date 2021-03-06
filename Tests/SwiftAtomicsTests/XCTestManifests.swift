#if !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
import XCTest

extension AtomicsBasicTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AtomicsBasicTests = [
        ("testBool", testBool),
        ("testFence", testFence),
        ("testInt", testInt),
        ("testInt16", testInt16),
        ("testInt32", testInt32),
        ("testInt64", testInt64),
        ("testInt8", testInt8),
        ("testOpaquePointer", testOpaquePointer),
        ("testOpaquePointerOptional", testOpaquePointerOptional),
        ("testTaggedMutableRawPointer", testTaggedMutableRawPointer),
        ("testTaggedOptionalMutableRawPointer", testTaggedOptionalMutableRawPointer),
        ("testTaggedOptionalRawPointer", testTaggedOptionalRawPointer),
        ("testTaggedRawPointer", testTaggedRawPointer),
        ("testUInt", testUInt),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testUInt8", testUInt8),
        ("testUnsafeMutablePointer", testUnsafeMutablePointer),
        ("testUnsafeMutablePointerOptional", testUnsafeMutablePointerOptional),
        ("testUnsafeMutableRawPointer", testUnsafeMutableRawPointer),
        ("testUnsafeMutableRawPointerOptional", testUnsafeMutableRawPointerOptional),
        ("testUnsafePointer", testUnsafePointer),
        ("testUnsafePointerOptional", testUnsafePointerOptional),
        ("testUnsafeRawPointer", testUnsafeRawPointer),
        ("testUnsafeRawPointerOptional", testUnsafeRawPointerOptional),
    ]
}

extension AtomicsRaceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AtomicsRaceTests = [
        ("testRaceCrash", testRaceCrash),
        ("testRacePointerCAS", testRacePointerCAS),
        ("testRacePointerLoadCAS", testRacePointerLoadCAS),
        ("testRacePointerSwap", testRacePointerSwap),
        ("testRaceSpinLock", testRaceSpinLock),
    ]
}

extension ReferenceRaceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ReferenceRaceTests = [
        ("testRaceAtomicReference", testRaceAtomicReference),
    ]
}

extension ReferenceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ReferenceTests = [
        ("testUnmanaged", testUnmanaged),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AtomicsBasicTests.__allTests__AtomicsBasicTests),
        testCase(AtomicsRaceTests.__allTests__AtomicsRaceTests),
        testCase(ReferenceRaceTests.__allTests__ReferenceRaceTests),
        testCase(ReferenceTests.__allTests__ReferenceTests),
    ]
}
#endif
