//
//  ClangAtomicsTests.swift
//  AtomicsTests
//

import XCTest
import Dispatch

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import func Darwin.C.stdlib.arc4random
#else // assuming os(Linux)
import func Glibc.random
#endif

import ClangAtomics

#if swift(>=4.0)
extension FixedWidthInteger
{
  // returns a positive random integer greater than 0 and less-than-or-equal to Self.max/2
  // the least significant bit is always set.
  static func randomPositive() -> Self
  {
    var t = Self()
    for _ in 0...((t.bitWidth-1)/32)
    {
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      t = t<<32 &+ Self(truncatingIfNeeded: arc4random())
    #else // probably Linux
      t = t<<32 &+ Self(truncatingIfNeeded: random())
    #endif
    }
    return (t|1) & (Self.max>>1)
  }
}
#else
extension UInt
{
  // returns a positive random integer greater than 0 and less-than-or-equal to UInt32.max/2
  // the least significant bit is always set.
  static func randomPositive() -> UInt
  {
  #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    return UInt(arc4random() & 0x3fff_fffe + 1)
  #else
    return UInt(random() & 0x3fff_fffe + 1)
  #endif
  }
}
#endif

public class ClangAtomicsTests: XCTestCase
{
  public static var allTests = [
    ("testMutablePointer", testMutablePointer),
    ("testPointer", testPointer),
    ("testBool", testBool),
    ("testFence", testFence),
  ]

  public func testInt()
  {
    var i = ClangAtomicsInt()
    ClangAtomicsIntInit(0, &i)
    XCTAssert(ClangAtomicsIntLoad(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int.randomPositive()
    let r2 = Int.randomPositive()
    let r3 = Int.randomPositive()
#else
    let r1 = Int(UInt.randomPositive())
    let r2 = Int(UInt.randomPositive())
    let r3 = Int(UInt.randomPositive())
#endif

    ClangAtomicsIntStore(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsIntLoad(&i, .relaxed))

    var j = ClangAtomicsIntSwap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsIntLoad(&i, .relaxed))

    j = ClangAtomicsIntAdd(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsIntLoad(&i, .relaxed))

    j = ClangAtomicsIntSub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsIntLoad(&i, .relaxed))

    ClangAtomicsIntStore(r1, &i, .relaxed)
    j = ClangAtomicsIntOr(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsIntLoad(&i, .relaxed))

    ClangAtomicsIntStore(r2, &i, .relaxed)
    j = ClangAtomicsIntXor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsIntLoad(&i, .relaxed))

    ClangAtomicsIntStore(r1, &i, .relaxed)
    j = ClangAtomicsIntAnd(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsIntLoad(&i, .relaxed))

    j = r1
    ClangAtomicsIntStore(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsIntStrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsIntLoad(&i, .relaxed))

    j = r2
    ClangAtomicsIntStore(r1, &i, .relaxed)
    while(!ClangAtomicsIntWeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsIntLoad(&i, .relaxed))
  }

  public func testUInt()
  {
    var i = ClangAtomicsUInt()
    ClangAtomicsUIntInit(0, &i)
    XCTAssert(ClangAtomicsUIntLoad(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt.randomPositive()
    let r2 = UInt.randomPositive()
    let r3 = UInt.randomPositive()
#else
    let r1 = UInt(UInt.randomPositive())
    let r2 = UInt(UInt.randomPositive())
    let r3 = UInt(UInt.randomPositive())
#endif

    ClangAtomicsUIntStore(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsUIntLoad(&i, .relaxed))

    var j = ClangAtomicsUIntSwap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsUIntLoad(&i, .relaxed))

    j = ClangAtomicsUIntAdd(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsUIntLoad(&i, .relaxed))

    j = ClangAtomicsUIntSub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsUIntLoad(&i, .relaxed))

    ClangAtomicsUIntStore(r1, &i, .relaxed)
    j = ClangAtomicsUIntOr(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsUIntLoad(&i, .relaxed))

    ClangAtomicsUIntStore(r2, &i, .relaxed)
    j = ClangAtomicsUIntXor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsUIntLoad(&i, .relaxed))

    ClangAtomicsUIntStore(r1, &i, .relaxed)
    j = ClangAtomicsUIntAnd(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsUIntLoad(&i, .relaxed))

    j = r1
    ClangAtomicsUIntStore(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsUIntStrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsUIntLoad(&i, .relaxed))

    j = r2
    ClangAtomicsUIntStore(r1, &i, .relaxed)
    while(!ClangAtomicsUIntWeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsUIntLoad(&i, .relaxed))
  }

  public func testInt8()
  {
    var i = ClangAtomicsInt8()
    ClangAtomicsInt8Init(0, &i)
    XCTAssert(ClangAtomicsInt8Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int8.randomPositive()
    let r2 = Int8.randomPositive()
    let r3 = Int8.randomPositive()
#else
    let r1 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int8(truncatingBitPattern: UInt.randomPositive())
#endif

    ClangAtomicsInt8Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsInt8Load(&i, .relaxed))

    var j = ClangAtomicsInt8Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsInt8Load(&i, .relaxed))

    j = ClangAtomicsInt8Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsInt8Load(&i, .relaxed))

    j = ClangAtomicsInt8Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsInt8Load(&i, .relaxed))

    ClangAtomicsInt8Store(r1, &i, .relaxed)
    j = ClangAtomicsInt8Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsInt8Load(&i, .relaxed))

    ClangAtomicsInt8Store(r2, &i, .relaxed)
    j = ClangAtomicsInt8Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsInt8Load(&i, .relaxed))

    ClangAtomicsInt8Store(r1, &i, .relaxed)
    j = ClangAtomicsInt8And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsInt8Load(&i, .relaxed))

    j = r1
    ClangAtomicsInt8Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsInt8StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsInt8Load(&i, .relaxed))

    j = r2
    ClangAtomicsInt8Store(r1, &i, .relaxed)
    while(!ClangAtomicsInt8WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsInt8Load(&i, .relaxed))
  }

  public func testUInt8()
  {
    var i = ClangAtomicsUInt8()
    ClangAtomicsUInt8Init(0, &i)
    XCTAssert(ClangAtomicsUInt8Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt8.randomPositive()
    let r2 = UInt8.randomPositive()
    let r3 = UInt8.randomPositive()
#else
    let r1 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt8(truncatingBitPattern: UInt.randomPositive())
#endif

    ClangAtomicsUInt8Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsUInt8Load(&i, .relaxed))

    var j = ClangAtomicsUInt8Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsUInt8Load(&i, .relaxed))

    j = ClangAtomicsUInt8Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsUInt8Load(&i, .relaxed))

    j = ClangAtomicsUInt8Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsUInt8Load(&i, .relaxed))

    ClangAtomicsUInt8Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt8Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsUInt8Load(&i, .relaxed))

    ClangAtomicsUInt8Store(r2, &i, .relaxed)
    j = ClangAtomicsUInt8Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsUInt8Load(&i, .relaxed))

    ClangAtomicsUInt8Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt8And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsUInt8Load(&i, .relaxed))

    j = r1
    ClangAtomicsUInt8Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsUInt8StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsUInt8Load(&i, .relaxed))

    j = r2
    ClangAtomicsUInt8Store(r1, &i, .relaxed)
    while(!ClangAtomicsUInt8WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsUInt8Load(&i, .relaxed))
  }

  public func testInt16()
  {
    var i = ClangAtomicsInt16()
    ClangAtomicsInt16Init(0, &i)
    XCTAssert(ClangAtomicsInt16Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int16.randomPositive()
    let r2 = Int16.randomPositive()
    let r3 = Int16.randomPositive()
#else
    let r1 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int16(truncatingBitPattern: UInt.randomPositive())
#endif

    ClangAtomicsInt16Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsInt16Load(&i, .relaxed))

    var j = ClangAtomicsInt16Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsInt16Load(&i, .relaxed))

    j = ClangAtomicsInt16Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsInt16Load(&i, .relaxed))

    j = ClangAtomicsInt16Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsInt16Load(&i, .relaxed))

    ClangAtomicsInt16Store(r1, &i, .relaxed)
    j = ClangAtomicsInt16Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsInt16Load(&i, .relaxed))

    ClangAtomicsInt16Store(r2, &i, .relaxed)
    j = ClangAtomicsInt16Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsInt16Load(&i, .relaxed))

    ClangAtomicsInt16Store(r1, &i, .relaxed)
    j = ClangAtomicsInt16And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsInt16Load(&i, .relaxed))

    j = r1
    ClangAtomicsInt16Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsInt16StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsInt16Load(&i, .relaxed))

    j = r2
    ClangAtomicsInt16Store(r1, &i, .relaxed)
    while(!ClangAtomicsInt16WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsInt16Load(&i, .relaxed))
  }

  public func testUInt16()
  {
    var i = ClangAtomicsUInt16()
    ClangAtomicsUInt16Init(0, &i)
    XCTAssert(ClangAtomicsUInt16Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt16.randomPositive()
    let r2 = UInt16.randomPositive()
    let r3 = UInt16.randomPositive()
#else
    let r1 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt16(truncatingBitPattern: UInt.randomPositive())
#endif

    ClangAtomicsUInt16Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsUInt16Load(&i, .relaxed))

    var j = ClangAtomicsUInt16Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsUInt16Load(&i, .relaxed))

    j = ClangAtomicsUInt16Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsUInt16Load(&i, .relaxed))

    j = ClangAtomicsUInt16Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsUInt16Load(&i, .relaxed))

    ClangAtomicsUInt16Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt16Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsUInt16Load(&i, .relaxed))

    ClangAtomicsUInt16Store(r2, &i, .relaxed)
    j = ClangAtomicsUInt16Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsUInt16Load(&i, .relaxed))

    ClangAtomicsUInt16Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt16And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsUInt16Load(&i, .relaxed))

    j = r1
    ClangAtomicsUInt16Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsUInt16StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsUInt16Load(&i, .relaxed))

    j = r2
    ClangAtomicsUInt16Store(r1, &i, .relaxed)
    while(!ClangAtomicsUInt16WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsUInt16Load(&i, .relaxed))
  }

  public func testInt32()
  {
    var i = ClangAtomicsInt32()
    ClangAtomicsInt32Init(0, &i)
    XCTAssert(ClangAtomicsInt32Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int32.randomPositive()
    let r2 = Int32.randomPositive()
    let r3 = Int32.randomPositive()
#else
    let r1 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int32(truncatingBitPattern: UInt.randomPositive())
#endif

    ClangAtomicsInt32Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsInt32Load(&i, .relaxed))

    var j = ClangAtomicsInt32Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsInt32Load(&i, .relaxed))

    j = ClangAtomicsInt32Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsInt32Load(&i, .relaxed))

    j = ClangAtomicsInt32Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsInt32Load(&i, .relaxed))

    ClangAtomicsInt32Store(r1, &i, .relaxed)
    j = ClangAtomicsInt32Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsInt32Load(&i, .relaxed))

    ClangAtomicsInt32Store(r2, &i, .relaxed)
    j = ClangAtomicsInt32Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsInt32Load(&i, .relaxed))

    ClangAtomicsInt32Store(r1, &i, .relaxed)
    j = ClangAtomicsInt32And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsInt32Load(&i, .relaxed))

    j = r1
    ClangAtomicsInt32Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsInt32StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsInt32Load(&i, .relaxed))

    j = r2
    ClangAtomicsInt32Store(r1, &i, .relaxed)
    while(!ClangAtomicsInt32WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsInt32Load(&i, .relaxed))
  }

  public func testUInt32()
  {
    var i = ClangAtomicsUInt32()
    ClangAtomicsUInt32Init(0, &i)
    XCTAssert(ClangAtomicsUInt32Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt32.randomPositive()
    let r2 = UInt32.randomPositive()
    let r3 = UInt32.randomPositive()
#else
    let r1 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt32(truncatingBitPattern: UInt.randomPositive())
#endif

    ClangAtomicsUInt32Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsUInt32Load(&i, .relaxed))

    var j = ClangAtomicsUInt32Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsUInt32Load(&i, .relaxed))

    j = ClangAtomicsUInt32Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsUInt32Load(&i, .relaxed))

    j = ClangAtomicsUInt32Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsUInt32Load(&i, .relaxed))

    ClangAtomicsUInt32Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt32Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsUInt32Load(&i, .relaxed))

    ClangAtomicsUInt32Store(r2, &i, .relaxed)
    j = ClangAtomicsUInt32Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsUInt32Load(&i, .relaxed))

    ClangAtomicsUInt32Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt32And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsUInt32Load(&i, .relaxed))

    j = r1
    ClangAtomicsUInt32Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsUInt32StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsUInt32Load(&i, .relaxed))

    j = r2
    ClangAtomicsUInt32Store(r1, &i, .relaxed)
    while(!ClangAtomicsUInt32WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsUInt32Load(&i, .relaxed))
  }

  public func testInt64()
  {
    var i = ClangAtomicsInt64()
    ClangAtomicsInt64Init(0, &i)
    XCTAssert(ClangAtomicsInt64Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int64.randomPositive()
    let r2 = Int64.randomPositive()
    let r3 = Int64.randomPositive()
#else
    let r1 = Int64(UInt.randomPositive())
    let r2 = Int64(UInt.randomPositive())
    let r3 = Int64(UInt.randomPositive())
#endif

    ClangAtomicsInt64Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsInt64Load(&i, .relaxed))

    var j = ClangAtomicsInt64Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsInt64Load(&i, .relaxed))

    j = ClangAtomicsInt64Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsInt64Load(&i, .relaxed))

    j = ClangAtomicsInt64Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsInt64Load(&i, .relaxed))

    ClangAtomicsInt64Store(r1, &i, .relaxed)
    j = ClangAtomicsInt64Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsInt64Load(&i, .relaxed))

    ClangAtomicsInt64Store(r2, &i, .relaxed)
    j = ClangAtomicsInt64Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsInt64Load(&i, .relaxed))

    ClangAtomicsInt64Store(r1, &i, .relaxed)
    j = ClangAtomicsInt64And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsInt64Load(&i, .relaxed))

    j = r1
    ClangAtomicsInt64Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsInt64StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsInt64Load(&i, .relaxed))

    j = r2
    ClangAtomicsInt64Store(r1, &i, .relaxed)
    while(!ClangAtomicsInt64WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsInt64Load(&i, .relaxed))
  }

  public func testUInt64()
  {
    var i = ClangAtomicsUInt64()
    ClangAtomicsUInt64Init(0, &i)
    XCTAssert(ClangAtomicsUInt64Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt64.randomPositive()
    let r2 = UInt64.randomPositive()
    let r3 = UInt64.randomPositive()
#else
    let r1 = UInt64(UInt.randomPositive())
    let r2 = UInt64(UInt.randomPositive())
    let r3 = UInt64(UInt.randomPositive())
#endif

    ClangAtomicsUInt64Store(r1, &i, .relaxed)
    XCTAssert(r1 == ClangAtomicsUInt64Load(&i, .relaxed))

    var j = ClangAtomicsUInt64Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsUInt64Load(&i, .relaxed))

    j = ClangAtomicsUInt64Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, ClangAtomicsUInt64Load(&i, .relaxed))

    j = ClangAtomicsUInt64Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, ClangAtomicsUInt64Load(&i, .relaxed))

    ClangAtomicsUInt64Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt64Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, ClangAtomicsUInt64Load(&i, .relaxed))

    ClangAtomicsUInt64Store(r2, &i, .relaxed)
    j = ClangAtomicsUInt64Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, ClangAtomicsUInt64Load(&i, .relaxed))

    ClangAtomicsUInt64Store(r1, &i, .relaxed)
    j = ClangAtomicsUInt64And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, ClangAtomicsUInt64Load(&i, .relaxed))

    j = r1
    ClangAtomicsUInt64Store(r1, &i, .relaxed)
    XCTAssertTrue(ClangAtomicsUInt64StrongCAS(&j, r2, &i, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsUInt64Load(&i, .relaxed))

    j = r2
    ClangAtomicsUInt64Store(r1, &i, .relaxed)
    while(!ClangAtomicsUInt64WeakCAS(&j, r3, &i, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsUInt64Load(&i, .relaxed))
  }

  public func testMutablePointer()
  {
    var p = ClangAtomicsMutablePointer()
    ClangAtomicsMutablePointerInit(nil, &p)
    XCTAssert(ClangAtomicsMutablePointerLoad(&p, .relaxed) == nil)

    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())

    ClangAtomicsMutablePointerStore(r1, &p, .relaxed)
    XCTAssert(r1 == ClangAtomicsMutablePointerLoad(&p, .relaxed))

    var j = ClangAtomicsMutablePointerSwap(r2, &p, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsMutablePointerLoad(&p, .relaxed))

    j = r1
    ClangAtomicsMutablePointerStore(r1, &p, .relaxed)
    XCTAssertTrue(ClangAtomicsMutablePointerStrongCAS(&j, r2, &p, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsMutablePointerLoad(&p, .relaxed))

    j = r2
    ClangAtomicsMutablePointerStore(r1, &p, .relaxed)
    while(!ClangAtomicsMutablePointerWeakCAS(&j, r3, &p, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsMutablePointerLoad(&p, .relaxed))
  }

  public func testPointer()
  {
    var p = ClangAtomicsPointer()
    ClangAtomicsPointerInit(nil, &p)
    XCTAssert(ClangAtomicsPointerLoad(&p, .relaxed) == nil)

    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())

    ClangAtomicsPointerStore(r1, &p, .relaxed)
    XCTAssert(r1 == ClangAtomicsPointerLoad(&p, .relaxed))

    var j = ClangAtomicsPointerSwap(r2, &p, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, ClangAtomicsPointerLoad(&p, .relaxed))

    j = r1
    ClangAtomicsPointerStore(r1, &p, .relaxed)
    XCTAssertTrue(ClangAtomicsPointerStrongCAS(&j, r2, &p, .relaxed, .relaxed))
    XCTAssertEqual(r2, ClangAtomicsPointerLoad(&p, .relaxed))

    j = r2
    ClangAtomicsPointerStore(r1, &p, .relaxed)
    while(!ClangAtomicsPointerWeakCAS(&j, r3, &p, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, ClangAtomicsPointerLoad(&p, .relaxed))
  }

  public func testBool()
  {
    var boolean = ClangAtomicsBoolean()
    ClangAtomicsBooleanInit(false, &boolean)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == false)

    ClangAtomicsBooleanStore(false, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == false)

    ClangAtomicsBooleanStore(true, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == true)

    ClangAtomicsBooleanStore(false, &boolean, .relaxed)
    ClangAtomicsBooleanOr(true, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == true)
    ClangAtomicsBooleanOr(false, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == true)
    ClangAtomicsBooleanStore(false, &boolean, .relaxed)
    ClangAtomicsBooleanOr(false, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == false)
    ClangAtomicsBooleanOr(true, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == true)

    ClangAtomicsBooleanAnd(false, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == false)
    ClangAtomicsBooleanAnd(true, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == false)

    ClangAtomicsBooleanXor(false, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == false)
    ClangAtomicsBooleanXor(true, &boolean, .relaxed)
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == true)

    let old = ClangAtomicsBooleanSwap(false, &boolean, .relaxed)
    XCTAssert(old == true)
    XCTAssert(ClangAtomicsBooleanSwap(true, &boolean, .relaxed) == false)

    var current = true
    XCTAssert(ClangAtomicsBooleanLoad(&boolean, .relaxed) == current)
    ClangAtomicsBooleanStrongCAS(&current, false, &boolean, .relaxed, .relaxed)
    current = ClangAtomicsBooleanLoad(&boolean, .relaxed)
    XCTAssert(current == false)
    if ClangAtomicsBooleanStrongCAS(&current, true, &boolean, .relaxed, .relaxed)
    {
      current = !current
      XCTAssert(ClangAtomicsBooleanWeakCAS(&current, false, &boolean, .relaxed, .relaxed))
      current = !current
      XCTAssert(ClangAtomicsBooleanWeakCAS(&current, true, &boolean, .relaxed, .relaxed))
    }
  }

public func testFence()
  {
    ThreadFence(.release)
    ThreadFence(.acquire)
  }
}

