//
//  CAtomicsTests.swift
//  AtomicsTests
//

import XCTest
import Dispatch

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import func Darwin.C.stdlib.arc4random
#else // assuming os(Linux)
import func Glibc.random
#endif

import CAtomics

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

public class CAtomicsTests: XCTestCase
{
  public static var allTests = [
    ("testMutablePointer", testMutablePointer),
    ("testPointer", testPointer),
    ("testBool", testBool),
    ("testFence", testFence),
  ]

  public func testInt()
  {
    var i = CAtomicsInt()
    CAtomicsIntInit(0, &i)
    XCTAssert(CAtomicsIntLoad(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int.randomPositive()
    let r2 = Int.randomPositive()
    let r3 = Int.randomPositive()
#else
    let r1 = Int(UInt.randomPositive())
    let r2 = Int(UInt.randomPositive())
    let r3 = Int(UInt.randomPositive())
#endif

    CAtomicsIntStore(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsIntLoad(&i, .relaxed))

    var j = CAtomicsIntSwap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsIntLoad(&i, .relaxed))

    j = CAtomicsIntAdd(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsIntLoad(&i, .relaxed))

    j = CAtomicsIntSub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsIntLoad(&i, .relaxed))

    CAtomicsIntStore(r1, &i, .relaxed)
    j = CAtomicsIntOr(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsIntLoad(&i, .relaxed))

    CAtomicsIntStore(r2, &i, .relaxed)
    j = CAtomicsIntXor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsIntLoad(&i, .relaxed))

    CAtomicsIntStore(r1, &i, .relaxed)
    j = CAtomicsIntAnd(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsIntLoad(&i, .relaxed))

    j = r1
    CAtomicsIntStore(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsIntCAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsIntLoad(&i, .relaxed))

    j = r2
    CAtomicsIntStore(r1, &i, .relaxed)
    while(!CAtomicsIntCAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsIntLoad(&i, .relaxed))
  }

  public func testUInt()
  {
    var i = CAtomicsUInt()
    CAtomicsUIntInit(0, &i)
    XCTAssert(CAtomicsUIntLoad(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt.randomPositive()
    let r2 = UInt.randomPositive()
    let r3 = UInt.randomPositive()
#else
    let r1 = UInt(UInt.randomPositive())
    let r2 = UInt(UInt.randomPositive())
    let r3 = UInt(UInt.randomPositive())
#endif

    CAtomicsUIntStore(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsUIntLoad(&i, .relaxed))

    var j = CAtomicsUIntSwap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsUIntLoad(&i, .relaxed))

    j = CAtomicsUIntAdd(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsUIntLoad(&i, .relaxed))

    j = CAtomicsUIntSub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsUIntLoad(&i, .relaxed))

    CAtomicsUIntStore(r1, &i, .relaxed)
    j = CAtomicsUIntOr(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsUIntLoad(&i, .relaxed))

    CAtomicsUIntStore(r2, &i, .relaxed)
    j = CAtomicsUIntXor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsUIntLoad(&i, .relaxed))

    CAtomicsUIntStore(r1, &i, .relaxed)
    j = CAtomicsUIntAnd(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsUIntLoad(&i, .relaxed))

    j = r1
    CAtomicsUIntStore(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsUIntCAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsUIntLoad(&i, .relaxed))

    j = r2
    CAtomicsUIntStore(r1, &i, .relaxed)
    while(!CAtomicsUIntCAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsUIntLoad(&i, .relaxed))
  }

  public func testInt8()
  {
    var i = CAtomicsInt8()
    CAtomicsInt8Init(0, &i)
    XCTAssert(CAtomicsInt8Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int8.randomPositive()
    let r2 = Int8.randomPositive()
    let r3 = Int8.randomPositive()
#else
    let r1 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int8(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsInt8Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsInt8Load(&i, .relaxed))

    var j = CAtomicsInt8Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsInt8Load(&i, .relaxed))

    j = CAtomicsInt8Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsInt8Load(&i, .relaxed))

    j = CAtomicsInt8Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsInt8Load(&i, .relaxed))

    CAtomicsInt8Store(r1, &i, .relaxed)
    j = CAtomicsInt8Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsInt8Load(&i, .relaxed))

    CAtomicsInt8Store(r2, &i, .relaxed)
    j = CAtomicsInt8Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsInt8Load(&i, .relaxed))

    CAtomicsInt8Store(r1, &i, .relaxed)
    j = CAtomicsInt8And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsInt8Load(&i, .relaxed))

    j = r1
    CAtomicsInt8Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsInt8CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsInt8Load(&i, .relaxed))

    j = r2
    CAtomicsInt8Store(r1, &i, .relaxed)
    while(!CAtomicsInt8CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsInt8Load(&i, .relaxed))
  }

  public func testUInt8()
  {
    var i = CAtomicsUInt8()
    CAtomicsUInt8Init(0, &i)
    XCTAssert(CAtomicsUInt8Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt8.randomPositive()
    let r2 = UInt8.randomPositive()
    let r3 = UInt8.randomPositive()
#else
    let r1 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt8(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsUInt8Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsUInt8Load(&i, .relaxed))

    var j = CAtomicsUInt8Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsUInt8Load(&i, .relaxed))

    j = CAtomicsUInt8Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsUInt8Load(&i, .relaxed))

    j = CAtomicsUInt8Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsUInt8Load(&i, .relaxed))

    CAtomicsUInt8Store(r1, &i, .relaxed)
    j = CAtomicsUInt8Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsUInt8Load(&i, .relaxed))

    CAtomicsUInt8Store(r2, &i, .relaxed)
    j = CAtomicsUInt8Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsUInt8Load(&i, .relaxed))

    CAtomicsUInt8Store(r1, &i, .relaxed)
    j = CAtomicsUInt8And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsUInt8Load(&i, .relaxed))

    j = r1
    CAtomicsUInt8Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsUInt8CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsUInt8Load(&i, .relaxed))

    j = r2
    CAtomicsUInt8Store(r1, &i, .relaxed)
    while(!CAtomicsUInt8CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsUInt8Load(&i, .relaxed))
  }

  public func testInt16()
  {
    var i = CAtomicsInt16()
    CAtomicsInt16Init(0, &i)
    XCTAssert(CAtomicsInt16Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int16.randomPositive()
    let r2 = Int16.randomPositive()
    let r3 = Int16.randomPositive()
#else
    let r1 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int16(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsInt16Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsInt16Load(&i, .relaxed))

    var j = CAtomicsInt16Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsInt16Load(&i, .relaxed))

    j = CAtomicsInt16Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsInt16Load(&i, .relaxed))

    j = CAtomicsInt16Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsInt16Load(&i, .relaxed))

    CAtomicsInt16Store(r1, &i, .relaxed)
    j = CAtomicsInt16Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsInt16Load(&i, .relaxed))

    CAtomicsInt16Store(r2, &i, .relaxed)
    j = CAtomicsInt16Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsInt16Load(&i, .relaxed))

    CAtomicsInt16Store(r1, &i, .relaxed)
    j = CAtomicsInt16And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsInt16Load(&i, .relaxed))

    j = r1
    CAtomicsInt16Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsInt16CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsInt16Load(&i, .relaxed))

    j = r2
    CAtomicsInt16Store(r1, &i, .relaxed)
    while(!CAtomicsInt16CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsInt16Load(&i, .relaxed))
  }

  public func testUInt16()
  {
    var i = CAtomicsUInt16()
    CAtomicsUInt16Init(0, &i)
    XCTAssert(CAtomicsUInt16Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt16.randomPositive()
    let r2 = UInt16.randomPositive()
    let r3 = UInt16.randomPositive()
#else
    let r1 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt16(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsUInt16Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsUInt16Load(&i, .relaxed))

    var j = CAtomicsUInt16Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsUInt16Load(&i, .relaxed))

    j = CAtomicsUInt16Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsUInt16Load(&i, .relaxed))

    j = CAtomicsUInt16Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsUInt16Load(&i, .relaxed))

    CAtomicsUInt16Store(r1, &i, .relaxed)
    j = CAtomicsUInt16Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsUInt16Load(&i, .relaxed))

    CAtomicsUInt16Store(r2, &i, .relaxed)
    j = CAtomicsUInt16Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsUInt16Load(&i, .relaxed))

    CAtomicsUInt16Store(r1, &i, .relaxed)
    j = CAtomicsUInt16And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsUInt16Load(&i, .relaxed))

    j = r1
    CAtomicsUInt16Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsUInt16CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsUInt16Load(&i, .relaxed))

    j = r2
    CAtomicsUInt16Store(r1, &i, .relaxed)
    while(!CAtomicsUInt16CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsUInt16Load(&i, .relaxed))
  }

  public func testInt32()
  {
    var i = CAtomicsInt32()
    CAtomicsInt32Init(0, &i)
    XCTAssert(CAtomicsInt32Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int32.randomPositive()
    let r2 = Int32.randomPositive()
    let r3 = Int32.randomPositive()
#else
    let r1 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int32(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsInt32Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsInt32Load(&i, .relaxed))

    var j = CAtomicsInt32Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsInt32Load(&i, .relaxed))

    j = CAtomicsInt32Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsInt32Load(&i, .relaxed))

    j = CAtomicsInt32Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsInt32Load(&i, .relaxed))

    CAtomicsInt32Store(r1, &i, .relaxed)
    j = CAtomicsInt32Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsInt32Load(&i, .relaxed))

    CAtomicsInt32Store(r2, &i, .relaxed)
    j = CAtomicsInt32Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsInt32Load(&i, .relaxed))

    CAtomicsInt32Store(r1, &i, .relaxed)
    j = CAtomicsInt32And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsInt32Load(&i, .relaxed))

    j = r1
    CAtomicsInt32Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsInt32CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsInt32Load(&i, .relaxed))

    j = r2
    CAtomicsInt32Store(r1, &i, .relaxed)
    while(!CAtomicsInt32CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsInt32Load(&i, .relaxed))
  }

  public func testUInt32()
  {
    var i = CAtomicsUInt32()
    CAtomicsUInt32Init(0, &i)
    XCTAssert(CAtomicsUInt32Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt32.randomPositive()
    let r2 = UInt32.randomPositive()
    let r3 = UInt32.randomPositive()
#else
    let r1 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt32(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsUInt32Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsUInt32Load(&i, .relaxed))

    var j = CAtomicsUInt32Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsUInt32Load(&i, .relaxed))

    j = CAtomicsUInt32Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsUInt32Load(&i, .relaxed))

    j = CAtomicsUInt32Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsUInt32Load(&i, .relaxed))

    CAtomicsUInt32Store(r1, &i, .relaxed)
    j = CAtomicsUInt32Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsUInt32Load(&i, .relaxed))

    CAtomicsUInt32Store(r2, &i, .relaxed)
    j = CAtomicsUInt32Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsUInt32Load(&i, .relaxed))

    CAtomicsUInt32Store(r1, &i, .relaxed)
    j = CAtomicsUInt32And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsUInt32Load(&i, .relaxed))

    j = r1
    CAtomicsUInt32Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsUInt32CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsUInt32Load(&i, .relaxed))

    j = r2
    CAtomicsUInt32Store(r1, &i, .relaxed)
    while(!CAtomicsUInt32CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsUInt32Load(&i, .relaxed))
  }

  public func testInt64()
  {
    var i = CAtomicsInt64()
    CAtomicsInt64Init(0, &i)
    XCTAssert(CAtomicsInt64Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int64.randomPositive()
    let r2 = Int64.randomPositive()
    let r3 = Int64.randomPositive()
#else
    let r1 = Int64(UInt.randomPositive())
    let r2 = Int64(UInt.randomPositive())
    let r3 = Int64(UInt.randomPositive())
#endif

    CAtomicsInt64Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsInt64Load(&i, .relaxed))

    var j = CAtomicsInt64Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsInt64Load(&i, .relaxed))

    j = CAtomicsInt64Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsInt64Load(&i, .relaxed))

    j = CAtomicsInt64Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsInt64Load(&i, .relaxed))

    CAtomicsInt64Store(r1, &i, .relaxed)
    j = CAtomicsInt64Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsInt64Load(&i, .relaxed))

    CAtomicsInt64Store(r2, &i, .relaxed)
    j = CAtomicsInt64Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsInt64Load(&i, .relaxed))

    CAtomicsInt64Store(r1, &i, .relaxed)
    j = CAtomicsInt64And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsInt64Load(&i, .relaxed))

    j = r1
    CAtomicsInt64Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsInt64CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsInt64Load(&i, .relaxed))

    j = r2
    CAtomicsInt64Store(r1, &i, .relaxed)
    while(!CAtomicsInt64CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsInt64Load(&i, .relaxed))
  }

  public func testUInt64()
  {
    var i = CAtomicsUInt64()
    CAtomicsUInt64Init(0, &i)
    XCTAssert(CAtomicsUInt64Load(&i, .relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt64.randomPositive()
    let r2 = UInt64.randomPositive()
    let r3 = UInt64.randomPositive()
#else
    let r1 = UInt64(UInt.randomPositive())
    let r2 = UInt64(UInt.randomPositive())
    let r3 = UInt64(UInt.randomPositive())
#endif

    CAtomicsUInt64Store(r1, &i, .relaxed)
    XCTAssert(r1 == CAtomicsUInt64Load(&i, .relaxed))

    var j = CAtomicsUInt64Swap(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsUInt64Load(&i, .relaxed))

    j = CAtomicsUInt64Add(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsUInt64Load(&i, .relaxed))

    j = CAtomicsUInt64Sub(r2, &i, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsUInt64Load(&i, .relaxed))

    CAtomicsUInt64Store(r1, &i, .relaxed)
    j = CAtomicsUInt64Or(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsUInt64Load(&i, .relaxed))

    CAtomicsUInt64Store(r2, &i, .relaxed)
    j = CAtomicsUInt64Xor(r1, &i, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsUInt64Load(&i, .relaxed))

    CAtomicsUInt64Store(r1, &i, .relaxed)
    j = CAtomicsUInt64And(r2, &i, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsUInt64Load(&i, .relaxed))

    j = r1
    CAtomicsUInt64Store(r1, &i, .relaxed)
    XCTAssertTrue(CAtomicsUInt64CAS(&j, r2, &i, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsUInt64Load(&i, .relaxed))

    j = r2
    CAtomicsUInt64Store(r1, &i, .relaxed)
    while(!CAtomicsUInt64CAS(&j, r3, &i, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsUInt64Load(&i, .relaxed))
  }

  public func testMutablePointer()
  {
    var p = CAtomicsMutablePointer()
    CAtomicsMutablePointerInit(nil, &p)
    XCTAssert(CAtomicsMutablePointerLoad(&p, .relaxed) == nil)

    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())

    CAtomicsMutablePointerStore(r1, &p, .relaxed)
    XCTAssert(r1 == CAtomicsMutablePointerLoad(&p, .relaxed))

    var j = CAtomicsMutablePointerSwap(r2, &p, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsMutablePointerLoad(&p, .relaxed))

    j = r1
    CAtomicsMutablePointerStore(r1, &p, .relaxed)
    XCTAssertTrue(CAtomicsMutablePointerCAS(&j, r2, &p, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsMutablePointerLoad(&p, .relaxed))

    j = r2
    CAtomicsMutablePointerStore(r1, &p, .relaxed)
    while(!CAtomicsMutablePointerCAS(&j, r3, &p, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsMutablePointerLoad(&p, .relaxed))
  }

  public func testPointer()
  {
    var p = CAtomicsPointer()
    CAtomicsPointerInit(nil, &p)
    XCTAssert(CAtomicsPointerLoad(&p, .relaxed) == nil)

    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())

    CAtomicsPointerStore(r1, &p, .relaxed)
    XCTAssert(r1 == CAtomicsPointerLoad(&p, .relaxed))

    var j = CAtomicsPointerSwap(r2, &p, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsPointerLoad(&p, .relaxed))

    j = r1
    CAtomicsPointerStore(r1, &p, .relaxed)
    XCTAssertTrue(CAtomicsPointerCAS(&j, r2, &p, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsPointerLoad(&p, .relaxed))

    j = r2
    CAtomicsPointerStore(r1, &p, .relaxed)
    while(!CAtomicsPointerCAS(&j, r3, &p, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsPointerLoad(&p, .relaxed))
  }

  public func testBool()
  {
    var boolean = CAtomicsBoolean()
    CAtomicsBooleanInit(false, &boolean)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == false)

    CAtomicsBooleanStore(false, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == false)

    CAtomicsBooleanStore(true, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == true)

    CAtomicsBooleanStore(false, &boolean, .relaxed)
    CAtomicsBooleanOr(true, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == true)
    CAtomicsBooleanOr(false, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == true)
    CAtomicsBooleanStore(false, &boolean, .relaxed)
    CAtomicsBooleanOr(false, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == false)
    CAtomicsBooleanOr(true, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == true)

    CAtomicsBooleanAnd(false, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == false)
    CAtomicsBooleanAnd(true, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == false)

    CAtomicsBooleanXor(false, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == false)
    CAtomicsBooleanXor(true, &boolean, .relaxed)
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == true)

    let old = CAtomicsBooleanSwap(false, &boolean, .relaxed)
    XCTAssert(old == true)
    XCTAssert(CAtomicsBooleanSwap(true, &boolean, .relaxed) == false)

    var current = true
    XCTAssert(CAtomicsBooleanLoad(&boolean, .relaxed) == current)
    CAtomicsBooleanCAS(&current, false, &boolean, .strong, .relaxed, .relaxed)
    current = CAtomicsBooleanLoad(&boolean, .relaxed)
    XCTAssert(current == false)
    if CAtomicsBooleanCAS(&current, true, &boolean, .strong, .relaxed, .relaxed)
    {
      current = !current
      XCTAssert(CAtomicsBooleanCAS(&current, false, &boolean, .weak, .relaxed, .relaxed))
      current = !current
      XCTAssert(CAtomicsBooleanCAS(&current, true, &boolean, .weak, .relaxed, .relaxed))
    }
  }

  public func testFence()
  {
    CAtomicsThreadFence(.release)
    CAtomicsThreadFence(.acquire)
  }
}

