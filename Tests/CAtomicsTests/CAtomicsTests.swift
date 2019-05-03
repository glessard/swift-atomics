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
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = Int.randomPositive()
    let r2 = Int.randomPositive()
    let r3 = Int.randomPositive()
#else
    let r1 = Int(UInt.randomPositive())
    let r2 = Int(UInt.randomPositive())
    let r3 = Int(UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testUInt()
  {
    var i = AtomicUInt()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = UInt.randomPositive()
    let r2 = UInt.randomPositive()
    let r3 = UInt.randomPositive()
#else
    let r1 = UInt(UInt.randomPositive())
    let r2 = UInt(UInt.randomPositive())
    let r3 = UInt(UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testInt8()
  {
    var i = AtomicInt8()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = Int8.randomPositive()
    let r2 = Int8.randomPositive()
    let r3 = Int8.randomPositive()
#else
    let r1 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int8(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testUInt8()
  {
    var i = AtomicUInt8()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = UInt8.randomPositive()
    let r2 = UInt8.randomPositive()
    let r3 = UInt8.randomPositive()
#else
    let r1 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt8(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testInt16()
  {
    var i = AtomicInt16()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = Int16.randomPositive()
    let r2 = Int16.randomPositive()
    let r3 = Int16.randomPositive()
#else
    let r1 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int16(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testUInt16()
  {
    var i = AtomicUInt16()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = UInt16.randomPositive()
    let r2 = UInt16.randomPositive()
    let r3 = UInt16.randomPositive()
#else
    let r1 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt16(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testInt32()
  {
    var i = AtomicInt32()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = Int32.randomPositive()
    let r2 = Int32.randomPositive()
    let r3 = Int32.randomPositive()
#else
    let r1 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int32(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testUInt32()
  {
    var i = AtomicUInt32()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = UInt32.randomPositive()
    let r2 = UInt32.randomPositive()
    let r3 = UInt32.randomPositive()
#else
    let r1 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt32(truncatingBitPattern: UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testInt64()
  {
    var i = AtomicInt64()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = Int64.randomPositive()
    let r2 = Int64.randomPositive()
    let r3 = Int64.randomPositive()
#else
    let r1 = Int64(UInt.randomPositive())
    let r2 = Int64(UInt.randomPositive())
    let r3 = Int64(UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testUInt64()
  {
    var i = AtomicUInt64()
    CAtomicsInitialize(&i, 0)
    XCTAssertEqual(0, CAtomicsLoad(&i, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&i))

#if swift(>=4.0)
    let r1 = UInt64.randomPositive()
    let r2 = UInt64.randomPositive()
    let r3 = UInt64.randomPositive()
#else
    let r1 = UInt64(UInt.randomPositive())
    let r2 = UInt64(UInt.randomPositive())
    let r3 = UInt64(UInt.randomPositive())
#endif

    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    var j = CAtomicsExchange(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsAdd(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, CAtomicsLoad(&i, .relaxed))

    j = CAtomicsSubtract(&i, r2, .relaxed)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseOr(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r2, .relaxed)
    j = CAtomicsBitwiseXor(&i, r1, .relaxed)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, CAtomicsLoad(&i, .relaxed))

    CAtomicsStore(&i, r1, .relaxed)
    j = CAtomicsBitwiseAnd(&i, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, CAtomicsLoad(&i, .relaxed))

    j = r1
    CAtomicsStore(&i, r1, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&i, &j, r2, .strong, .relaxed, .relaxed))
    XCTAssertEqual(r2, CAtomicsLoad(&i, .relaxed))

    j = r2
    CAtomicsStore(&i, r1, .relaxed)
    while(!CAtomicsCompareAndExchange(&i, &j, r3, .weak, .relaxed, .relaxed)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&i, .relaxed))
  }

  public func testBool()
  {
    var b = AtomicBool()
    CAtomicsInitialize(&b, false)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)
    XCTAssert(CAtomicsIsLockFree(&b))

    CAtomicsStore(&b, false, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)

    CAtomicsStore(&b, true, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == true)

    CAtomicsStore(&b, false, .relaxed)
    CAtomicsOr(&b, true, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == true)
    CAtomicsOr(&b, false, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == true)
    CAtomicsStore(&b, false, .relaxed)
    CAtomicsOr(&b, false, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)
    CAtomicsOr(&b, true, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == true)

    CAtomicsAnd(&b, false, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)
    CAtomicsAnd(&b, true, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)

    CAtomicsXor(&b, false, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)
    CAtomicsXor(&b, true, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == true)

    let old = CAtomicsExchange(&b, false, .relaxed)
    XCTAssert(old == true)
    XCTAssert(CAtomicsExchange(&b, true, .relaxed) == false)

    var current = true
    XCTAssert(CAtomicsLoad(&b, .relaxed) == current)
    CAtomicsCompareAndExchange(&b, &current, false, .strong, .relaxed, .relaxed)
    XCTAssert(CAtomicsLoad(&b, .relaxed) == false)

    XCTAssert(CAtomicsCompareAndExchange(&b, false, true, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&b, &current, false, .weak, .relaxed, .relaxed) {}
    while !CAtomicsCompareAndExchange(&b, !current, true, .weak, .relaxed) {}
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
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testAtomicRawPointer()
  {
    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!

    var p = AtomicRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testAtomicMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!

    var p = AtomicMutableRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testAtomicOptionalMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())

    var p = AtomicOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testAtomicOpaquePointer()
  {
    let r0 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r1 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r2 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r3 = OpaquePointer(bitPattern: UInt.randomPositive())!

    var p = AtomicOpaquePointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testAtomicOptionalOpaquePointer()
  {
    let r0 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r1 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r2 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r3 = OpaquePointer(bitPattern: UInt.randomPositive())

    var p = AtomicOptionalOpaquePointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
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
    let r0 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    var r1 = r0
    let r2 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 4)

    XCTAssertEqual(MemoryLayout<TaggedRawPointer>.size, MemoryLayout<UnsafeRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)

    XCTAssertEqual(r1.tag, 3)
    r1 = r0.incremented(with: r2.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)
    XCTAssertEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)
    r1.increment()
    XCTAssertEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag &- 1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedRawPointer()
  {
    let r0 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 0)
    let r1 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 1)
    let r2 = TaggedRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testTaggedMutableRawPointer()
  {
    let r0 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    var r1 = r0
    let r2 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 4)

    XCTAssertEqual(MemoryLayout<TaggedMutableRawPointer>.size, MemoryLayout<UnsafeMutableRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)

    XCTAssertEqual(r1.tag, 3)
    r1 = r0.incremented(with: r2.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)
    XCTAssertEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)
    r1.increment()
    XCTAssertEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag &- 1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedMutableRawPointer()
  {
    let r0 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 0)
    let r1 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 1)
    let r2 = TaggedMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedMutableRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testTaggedOptionalRawPointer()
  {
    let r0 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    var r1 = r0
    let r2 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 4)

    XCTAssertEqual(MemoryLayout<TaggedOptionalRawPointer>.size, MemoryLayout<UnsafeRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)

    XCTAssertEqual(r1.tag, 3)
    r1 = r0.incremented(with: r2.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)
    XCTAssertEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)
    r1.increment()
    XCTAssertEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag &- 1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedOptionalRawPointer()
  {
    let r0 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 0)
    let r1 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 1)
    let r2 = TaggedOptionalRawPointer(UnsafeRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedOptionalRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

  public func testTaggedOptionalMutableRawPointer()
  {
    let r0 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    var r1 = r0
    let r2 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 4)

    XCTAssertEqual(MemoryLayout<TaggedOptionalMutableRawPointer>.size, MemoryLayout<UnsafeMutableRawPointer>.size*2)

    XCTAssertEqual(r0, r1)
    r1 = r0.incremented()
    XCTAssertNotEqual(r0, r1)
    XCTAssertEqual(r0.ptr, r1.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)

    XCTAssertEqual(r1.tag, 3)
    r1 = r0.incremented(with: r2.ptr)
    XCTAssertEqual(r0.tag &+ 1, r1.tag)
    XCTAssertEqual(r1.ptr, r2.ptr)
    XCTAssertNotEqual(r1, r2)
    r1.increment()
    XCTAssertEqual(r1, r2)

    let r3 = r2.incremented()
    XCTAssertNotEqual(r2, r3)
    XCTAssertEqual(r2.ptr, r3.ptr)
    XCTAssertEqual(r2.tag, r3.tag &- 1)
    var r4 = r2
    r4.tag += 1
    XCTAssertEqual(r3, r4)
  }

  public func testAtomicTaggedOptionalMutableRawPointer()
  {
    let r0 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 0)
    let r1 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 1)
    let r2 = TaggedOptionalMutableRawPointer(UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), tag: 2)
    let r3 = r2.incremented()

    var p = AtomicTaggedOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
    XCTAssert(CAtomicsIsLockFree(&p))

    CAtomicsInitialize(&p, r0)
    XCTAssertEqual(r0, CAtomicsLoad(&p, .relaxed))

    CAtomicsStore(&p, r1, .relaxed)
    XCTAssertEqual(r1, CAtomicsLoad(&p, .relaxed))

    var j = CAtomicsExchange(&p, r2, .relaxed)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, CAtomicsLoad(&p, .relaxed))

    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r3, .strong, .relaxed))
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))

    XCTAssertFalse(CAtomicsCompareAndExchange(&p, j, r2, .strong, .relaxed))
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r3, r2, .strong, .relaxed))
    j = CAtomicsLoad(&p, .relaxed)
    XCTAssertTrue(CAtomicsCompareAndExchange(&p, r2, r1, .strong, .relaxed))
    while !CAtomicsCompareAndExchange(&p, &j, r3, .weak, .relaxed, .relaxed) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, CAtomicsLoad(&p, .relaxed))
  }

}
