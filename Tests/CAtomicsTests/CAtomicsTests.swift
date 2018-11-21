//
//  CAtomicsTests.swift
//  AtomicsTests
//
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import XCTest

import CAtomics

public class CAtomicsBasicTests: XCTestCase
{
  public func testInt()
  {
    var i = AtomicInt()
    i.initialize(0)
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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
    XCTAssertEqual(0, i.load(.relaxed))
    XCTAssert(i.isLockFree())

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
    XCTAssertEqual(r1, i.load(.relaxed))

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

  public func testBool()
  {
    var boolean = AtomicBool()
    boolean.initialize(false)
    XCTAssert(boolean.load(.relaxed) == false)
    XCTAssert(boolean.isLockFree())

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
}

extension CAtomicsBasicTests
{
  public func testAtomicOptionalRawPointer()
  {
    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())

    var p = AtomicOptionalRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicNonNullRawPointer()
  {
    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!

    var p = AtomicNonNullRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicNonNullMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!

    var p = AtomicNonNullMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicOptionalMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())

    var p = AtomicOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!

    var p = AtomicCacheLineAlignedMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedOptionalMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())

    var p = AtomicCacheLineAlignedOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedRawPointer()
  {
    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!

    var p = AtomicCacheLineAlignedRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedOptionalRawPointer()
  {
    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())

    var p = AtomicCacheLineAlignedOptionalRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicNonNullOpaquePointer()
  {
    let r0 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r1 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r2 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r3 = OpaquePointer(bitPattern: UInt.randomPositive())!

    var p = AtomicNonNullOpaquePointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicOptionalOpaquePointer()
  {
    let r0 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r1 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r2 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r3 = OpaquePointer(bitPattern: UInt.randomPositive())

    var p = AtomicOptionalOpaquePointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testFence()
  {
    CAtomicsThreadFence(.release)
    CAtomicsThreadFence(.acquire)
  }
}

protocol TaggedPointer: Equatable
{
  associatedtype Pointer: Equatable
  var ptr: Pointer { get }
  var tag: Int { get }
}

extension TaggedPointer
{
  static public func ==(lhs: Self, rhs: Self) -> Bool
  {
    return (lhs.ptr == rhs.ptr) && (lhs.tag == rhs.tag)
  }
}

protocol TaggedOptionalPointer: Equatable
{
  associatedtype Pointer: Equatable
  var ptr: Optional<Pointer> { get }
  var tag: Int { get }
}

extension TaggedOptionalPointer
{
  static public func ==(lhs: Self, rhs: Self) -> Bool
  {
    return (lhs.ptr == rhs.ptr) && (lhs.tag == rhs.tag)
  }
}

extension TaggedRawPointer: TaggedPointer {}
extension TaggedMutableRawPointer: TaggedPointer {}
extension TaggedOptionalRawPointer: TaggedOptionalPointer {}
extension TaggedOptionalMutableRawPointer: TaggedOptionalPointer {}

extension CAtomicsBasicTests
{
  public func testTaggedRawPointer()
  {
    let r0 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!)
    var r1 = r0
    let r2 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)

    XCTAssertEqual(MemoryLayout<TaggedRawPointer>.size, MemoryLayout<UnsafeRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag+1, r1.tag)

    XCTAssertEqual(r1.tag, 1)
    r1.increment()
    XCTAssertEqual(r1.tag, 2)
    XCTAssertEqual(r1.tag, r2.tag)
    XCTAssertNotEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag-1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedRawPointer()
  {
    let r0 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!)
    let r1 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 1)
    let r2 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedTaggedRawPointer()
  {
    let r0 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!)
    let r1 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 1)
    let r2 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    let r3 = r2.incremented()

    var p = AtomicCacheLineAlignedTaggedRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testTaggedMutableRawPointer()
  {
    let r0 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!)
    var r1 = r0
    let r2 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)

    XCTAssertEqual(MemoryLayout<TaggedMutableRawPointer>.size, MemoryLayout<UnsafeMutableRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag+1, r1.tag)

    XCTAssertEqual(r1.tag, 1)
    r1.increment()
    XCTAssertEqual(r1.tag, 2)
    XCTAssertEqual(r1.tag, r2.tag)
    XCTAssertNotEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag-1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedMutableRawPointer()
  {
    let r0 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!)
    let r1 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 1)
    let r2 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedTaggedMutableRawPointer()
  {
    let r0 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!)
    let r1 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 1)
    let r2 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    let r3 = r2.incremented()

    var p = AtomicCacheLineAlignedTaggedMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testTaggedOptionalRawPointer()
  {
    let r0 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()))
    var r1 = r0
    let r2 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 2)

    XCTAssertEqual(MemoryLayout<TaggedOptionalRawPointer>.size, MemoryLayout<UnsafeRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag+1, r1.tag)

    XCTAssertEqual(r1.tag, 1)
    r1.increment()
    XCTAssertEqual(r1.tag, 2)
    XCTAssertEqual(r1.tag, r2.tag)
    XCTAssertNotEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag-1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedOptionalRawPointer()
  {
    let r0 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()))
    let r1 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 1)
    let r2 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedOptionalRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedTaggedOptionalRawPointer()
  {
    let r0 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()))
    let r1 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 1)
    let r2 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    let r3 = r2.incremented()

    var p = AtomicCacheLineAlignedTaggedOptionalRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testTaggedOptionalMutableRawPointer()
  {
    let r0 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()))
    var r1 = r0
    let r2 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 2)

    XCTAssertEqual(MemoryLayout<TaggedOptionalMutableRawPointer>.size, MemoryLayout<UnsafeMutableRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag+1, r1.tag)

    XCTAssertEqual(r1.tag, 1)
    r1.increment()
    XCTAssertEqual(r1.tag, 2)
    XCTAssertEqual(r1.tag, r2.tag)
    XCTAssertNotEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag-1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedOptionalMutableRawPointer()
  {
    let r0 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()))
    let r1 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 1)
    let r2 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

  public func testAtomicCacheLineAlignedTaggedOptionalMutableRawPointer()
  {
    let r0 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()))
    let r1 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 1)
    let r2 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    let r3 = r2.incremented()

    var p = AtomicCacheLineAlignedTaggedOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3, p.load(.relaxed))
    XCTAssert(p.isLockFree())

    p.initialize(r0)
    XCTAssertEqual(r0, p.load(.relaxed))

    p.store(r1, .relaxed)
    XCTAssertEqual(r1, p.load(.relaxed))

    var j = p.swap(r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, p.load(.relaxed))

    XCTAssertTrue(p.CAS(r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, p.load(.relaxed))

    XCTAssertFalse(p.CAS(j, r2, .strong, .relaxed))
    XCTAssertTrue(p.CAS(r3, r2, .strong, .relaxed))
    j = p.load(.relaxed)
    XCTAssertTrue(p.CAS(r2, r1, .strong, .relaxed))
    while !p.loadCAS(&j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, p.load(.relaxed))
  }

}
