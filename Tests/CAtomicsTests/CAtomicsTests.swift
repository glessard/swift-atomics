//
//  CAtomicsTests.swift
//  AtomicsTests
//
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
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
    var i = AtomicInt()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int.randomPositive()
    let r2 = Int.randomPositive()
    let r3 = Int.randomPositive()
#else
    let r1 = Int(UInt.randomPositive())
    let r2 = Int(UInt.randomPositive())
    let r3 = Int(UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testUInt()
  {
    var i = AtomicUInt()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt.randomPositive()
    let r2 = UInt.randomPositive()
    let r3 = UInt.randomPositive()
#else
    let r1 = UInt(UInt.randomPositive())
    let r2 = UInt(UInt.randomPositive())
    let r3 = UInt(UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testInt8()
  {
    var i = AtomicInt8()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int8.randomPositive()
    let r2 = Int8.randomPositive()
    let r3 = Int8.randomPositive()
#else
    let r1 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int8(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testUInt8()
  {
    var i = AtomicUInt8()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt8.randomPositive()
    let r2 = UInt8.randomPositive()
    let r3 = UInt8.randomPositive()
#else
    let r1 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt8(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testInt16()
  {
    var i = AtomicInt16()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int16.randomPositive()
    let r2 = Int16.randomPositive()
    let r3 = Int16.randomPositive()
#else
    let r1 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int16(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testUInt16()
  {
    var i = AtomicUInt16()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt16.randomPositive()
    let r2 = UInt16.randomPositive()
    let r3 = UInt16.randomPositive()
#else
    let r1 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt16(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testInt32()
  {
    var i = AtomicInt32()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int32.randomPositive()
    let r2 = Int32.randomPositive()
    let r3 = Int32.randomPositive()
#else
    let r1 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int32(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testUInt32()
  {
    var i = AtomicUInt32()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt32.randomPositive()
    let r2 = UInt32.randomPositive()
    let r3 = UInt32.randomPositive()
#else
    let r1 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt32(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testInt64()
  {
    var i = AtomicInt64()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = Int64.randomPositive()
    let r2 = Int64.randomPositive()
    let r3 = Int64.randomPositive()
#else
    let r1 = Int64(UInt.randomPositive())
    let r2 = Int64(UInt.randomPositive())
    let r3 = Int64(UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
  }

  public func testUInt64()
  {
    var i = AtomicUInt64()
    i.initialize(0)
    XCTAssert(i.load(.relaxed) == 0)

#if swift(>=4.0)
    let r1 = UInt64.randomPositive()
    let r2 = UInt64.randomPositive()
    let r3 = UInt64.randomPositive()
#else
    let r1 = UInt64(UInt.randomPositive())
    let r2 = UInt64(UInt.randomPositive())
    let r3 = UInt64(UInt.randomPositive())
#endif

    i.store(r1, .relaxed)
    XCTAssert(r1 == i.load(.relaxed))

    var j = i.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load(.relaxed))

    j = i.fetch_add(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load(.relaxed))

    j = i.fetch_sub(r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_or(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load(.relaxed))

    i.store(r2, .relaxed)
    j = i.fetch_xor(r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load(.relaxed))

    i.store(r1, .relaxed)
    j = i.fetch_and(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load(.relaxed))

    j = r1
    i.store(r1, .relaxed)
    XCTAssertTrue(i.loadCAS(&j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, i.load(.relaxed))

    j = r2
    i.store(r1, .relaxed)
    while(!i.loadCAS(&j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load(.relaxed))
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
    var boolean = AtomicBool()
    boolean.initialize(false)
    XCTAssert(boolean.load(.relaxed) == false)

    boolean.store(false, .relaxed)
    XCTAssert(boolean.load(.relaxed) == false)

    boolean.store(true, .relaxed)
    XCTAssert(boolean.load(.relaxed) == true)

    boolean.store(false, .relaxed)
    boolean.fetch_or(true, .relaxed)
    XCTAssert(boolean.load(.relaxed) == true)
    boolean.fetch_or(false, .relaxed)
    XCTAssert(boolean.load(.relaxed) == true)
    boolean.store(false, .relaxed)
    boolean.fetch_or(false, .relaxed)
    XCTAssert(boolean.load(.relaxed) == false)
    boolean.fetch_or(true, .relaxed)
    XCTAssert(boolean.load(.relaxed) == true)

    boolean.fetch_and(false, .relaxed)
    XCTAssert(boolean.load(.relaxed) == false)
    boolean.fetch_and(true, .relaxed)
    XCTAssert(boolean.load(.relaxed) == false)

    boolean.fetch_xor(false, .relaxed)
    XCTAssert(boolean.load(.relaxed) == false)
    boolean.fetch_xor(true, .relaxed)
    XCTAssert(boolean.load(.relaxed) == true)

    let old = boolean.swap(false, .relaxed)
    XCTAssert(old == true)
    XCTAssert(boolean.swap(true, .relaxed) == false)

    var current = true
    XCTAssert(boolean.load(.relaxed) == current)
    boolean.loadCAS(&current, false, .strong, .relaxed, .relaxed)
    current = boolean.load(.relaxed)
    XCTAssert(current == false)
    if boolean.loadCAS(&current, true, .strong, .relaxed, .relaxed)
    {
      current = !current
      XCTAssert(boolean.loadCAS(&current, false, .weak, .relaxed, .relaxed))
      current = !current
      XCTAssert(boolean.loadCAS(&current, true, .weak, .relaxed, .relaxed))
    }
  }

  public func testFence()
  {
    CAtomicsThreadFence(.release)
    CAtomicsThreadFence(.acquire)
  }
}

