//
//  AtomicsTests.swift
//  AtomicsTests
//
//  Copyright © 2015-2018 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import XCTest

import SwiftAtomics

public class AtomicsBasicTests: XCTestCase
{
  public func testInt()
  {
    var i = AtomicInt(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = Int.randomPositive()
    let r2 = Int.randomPositive()
    let r3 = Int.randomPositive()
#else
    let r1 = Int(UInt.randomPositive())
    let r2 = Int(UInt.randomPositive())
    let r3 = Int(UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUInt()
  {
    var i = AtomicUInt(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = UInt.randomPositive()
    let r2 = UInt.randomPositive()
    let r3 = UInt.randomPositive()
#else
    let r1 = UInt(UInt.randomPositive())
    let r2 = UInt(UInt.randomPositive())
    let r3 = UInt(UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testInt8()
  {
    var i = AtomicInt8(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = Int8.randomPositive()
    let r2 = Int8.randomPositive()
    let r3 = Int8.randomPositive()
#else
    let r1 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int8(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int8(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUInt8()
  {
    var i = AtomicUInt8(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = UInt8.randomPositive()
    let r2 = UInt8.randomPositive()
    let r3 = UInt8.randomPositive()
#else
    let r1 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt8(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt8(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testInt16()
  {
    var i = AtomicInt16(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = Int16.randomPositive()
    let r2 = Int16.randomPositive()
    let r3 = Int16.randomPositive()
#else
    let r1 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int16(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int16(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUInt16()
  {
    var i = AtomicUInt16(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = UInt16.randomPositive()
    let r2 = UInt16.randomPositive()
    let r3 = UInt16.randomPositive()
#else
    let r1 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt16(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt16(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testInt32()
  {
    var i = AtomicInt32(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = Int32.randomPositive()
    let r2 = Int32.randomPositive()
    let r3 = Int32.randomPositive()
#else
    let r1 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r2 = Int32(truncatingBitPattern: UInt.randomPositive())
    let r3 = Int32(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUInt32()
  {
    var i = AtomicUInt32(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = UInt32.randomPositive()
    let r2 = UInt32.randomPositive()
    let r3 = UInt32.randomPositive()
#else
    let r1 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r2 = UInt32(truncatingBitPattern: UInt.randomPositive())
    let r3 = UInt32(truncatingBitPattern: UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testInt64()
  {
    var i = AtomicInt64(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = Int64.randomPositive()
    let r2 = Int64.randomPositive()
    let r3 = Int64.randomPositive()
#else
    let r1 = Int64(UInt.randomPositive())
    let r2 = Int64(UInt.randomPositive())
    let r3 = Int64(UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUInt64()
  {
    var i = AtomicUInt64(0)
    XCTAssertEqual(i.value, 0)
    i.initialize(1)
    XCTAssertEqual(i.value, 1)

#if swift(>=4.0)
    let r1 = UInt64.randomPositive()
    let r2 = UInt64.randomPositive()
    let r3 = UInt64.randomPositive()
#else
    let r1 = UInt64(UInt.randomPositive())
    let r2 = UInt64(UInt.randomPositive())
    let r3 = UInt64(UInt.randomPositive())
#endif

    i.store(r1)
    XCTAssertEqual(r1, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r2, i.load())

    j = i.add(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 &+ r2, i.load())

    j = i.subtract(r2)
    XCTAssertEqual(r1 &+ r2, j)
    XCTAssertEqual(r1, i.load())

    j = i.increment()
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 &+ 1, i.load())

    i.store(r3)
    j = i.decrement()
    XCTAssertEqual(r3, j)
    XCTAssertEqual(r3 &- 1, i.load())

    i.store(r1)
    j = i.bitwiseOr(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 | r2, i.load())

    i.store(r2)
    j = i.bitwiseXor(r1)
    XCTAssertEqual(r2, j)
    XCTAssertEqual(r1 ^ r2, i.load())

    i.store(r1)
    j = i.bitwiseAnd(r2)
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r1 & r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafeRawPointer()
  {
    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())!

    var i = AtomicRawPointer(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafeRawPointerOptional()
  {
    var n = AtomicOptionalRawPointer()
    XCTAssertEqual(n.pointer, nil)

    let r0 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeRawPointer(bitPattern: UInt.randomPositive())

    var i = AtomicOptionalRawPointer(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafeMutableRawPointer()
  {
    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!

    var i = AtomicMutableRawPointer(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafeMutableRawPointerOptional()
  {
    var n = AtomicOptionalMutableRawPointer()
    XCTAssertEqual(n.pointer, nil)

    let r0 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r1 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())

    var i = AtomicOptionalMutableRawPointer(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafePointer()
  {
    let r0 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())!
    let r1 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())!
    let r2 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())!
    let r3 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())!

    var i = AtomicPointer<Int64>(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafePointerOptional()
  {
    var n = AtomicOptionalPointer<Int64>()
    XCTAssertEqual(n.pointer, nil)

    let r0 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())
    let r1 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())
    let r2 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())
    let r3 = UnsafePointer<Int64>(bitPattern: UInt.randomPositive())

    var i = AtomicOptionalPointer<Int64>(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafeMutablePointer()
  {
    let r0 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())!
    let r1 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())!
    let r2 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())!
    let r3 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())!

    var i = AtomicMutablePointer<Int64>(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testUnsafeMutablePointerOptional()
  {
    var n = AtomicOptionalMutablePointer<Int64>()
    XCTAssertEqual(n.pointer, nil)

    let r0 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())
    let r1 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())
    let r2 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())
    let r3 = UnsafeMutablePointer<Int64>(bitPattern: UInt.randomPositive())

    var i = AtomicOptionalMutablePointer<Int64>(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testOpaquePointer()
  {
    let r0 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r1 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r2 = OpaquePointer(bitPattern: UInt.randomPositive())!
    let r3 = OpaquePointer(bitPattern: UInt.randomPositive())!

    var i = AtomicOpaquePointer(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testOpaquePointerOptional()
  {
    var n = AtomicOptionalOpaquePointer()
    XCTAssertEqual(n.pointer, nil)

    let r0 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r1 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r2 = OpaquePointer(bitPattern: UInt.randomPositive())
    let r3 = OpaquePointer(bitPattern: UInt.randomPositive())

    var i = AtomicOptionalOpaquePointer(r0)
    XCTAssertEqual(i.pointer, r0)

    i.initialize(r1)
    XCTAssertEqual(i.pointer, r1)

    i.store(r0)
    XCTAssertEqual(r0, i.load())

    var j = i.swap(r2)
    XCTAssertEqual(r0, j)
    XCTAssertEqual(r2, i.load())

    i.store(r1)
    XCTAssertTrue(i.CAS(current: r1, future: r2, type: .strong))
    XCTAssertEqual(r2, i.load())

    j = r2
    i.store(r1)
    while(!i.loadCAS(current: &j, future: r3)) {}
    XCTAssertEqual(r1, j)
    XCTAssertEqual(r3, i.load())
  }

  public func testTaggedRawPointer()
  {
    let r0 = (UnsafeRawPointer(bitPattern: UInt.randomPositive())!, 0)
    let r1 = (UnsafeRawPointer(bitPattern: UInt.randomPositive())!, 1)
    let r2 = (UnsafeRawPointer(bitPattern: UInt.randomPositive())!, 2)
    let r3 = (r2.0, r2.1+1)

    var p = AtomicTaggedRawPointer(r3)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    p.initialize((r3.0, r0.1))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r0.1, p.value.tag)

    p.store(r1, order: .release)
    XCTAssertEqual(r1.0, p.value.pointer)
    XCTAssertEqual(r1.1, p.value.tag)

    var j = p.swap(r2, order: .acqrel)
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    j = p.load(order: .acquire)
    XCTAssertEqual(r2.0, j.0)
    XCTAssertEqual(r2.1, j.1)

    XCTAssertTrue(p.CAS(current: r2, future: r3))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    XCTAssertFalse(p.CAS(current: j, future: r2, type: .weak))
    XCTAssertTrue(p.CAS(current: r3, future: r2))
    j = p.load(order: .relaxed)
    XCTAssertTrue(p.CAS(current: r2, future: r1))
    while !p.loadCAS(current: &j, future: r3) {}
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)
  }

  public func testTaggedOptionalRawPointer()
  {
    let r0 = (UnsafeRawPointer(bitPattern: UInt.randomPositive()), 0)
    let r1 = (UnsafeRawPointer(bitPattern: UInt.randomPositive()), 1)
    let r2 = (UnsafeRawPointer(bitPattern: UInt.randomPositive()), 2)
    let r3 = (r2.0, r2.1+1)

    var p = AtomicTaggedOptionalRawPointer(r3)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    p.initialize((r3.0, r0.1))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r0.1, p.value.tag)

    p.store(r1, order: .release)
    XCTAssertEqual(r1.0, p.value.pointer)
    XCTAssertEqual(r1.1, p.value.tag)

    var j = p.swap(r2, order: .acqrel)
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    j = p.load(order: .acquire)
    XCTAssertEqual(r2.0, j.0)
    XCTAssertEqual(r2.1, j.1)

    XCTAssertTrue(p.CAS(current: r2, future: r3))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    XCTAssertFalse(p.CAS(current: j, future: r2, type: .weak))
    XCTAssertTrue(p.CAS(current: r3, future: r2))
    j = p.load(order: .relaxed)
    XCTAssertTrue(p.CAS(current: r2, future: r1))
    while !p.loadCAS(current: &j, future: r3) {}
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)
  }

  public func testTaggedMutableRawPointer()
  {
    let r0 = (UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, 0)
    let r1 = (UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, 1)
    let r2 = (UnsafeMutableRawPointer(bitPattern: UInt.randomPositive())!, 2)
    let r3 = (r2.0, r2.1+1)

    var p = AtomicTaggedMutableRawPointer(r3)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    p.initialize((r3.0, r0.1))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r0.1, p.value.tag)

    p.store(r1, order: .release)
    XCTAssertEqual(r1.0, p.value.pointer)
    XCTAssertEqual(r1.1, p.value.tag)

    var j = p.swap(r2, order: .acqrel)
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    j = p.load(order: .acquire)
    XCTAssertEqual(r2.0, j.0)
    XCTAssertEqual(r2.1, j.1)

    XCTAssertTrue(p.CAS(current: r2, future: r3))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    XCTAssertFalse(p.CAS(current: j, future: r2, type: .weak))
    XCTAssertTrue(p.CAS(current: r3, future: r2))
    j = p.load(order: .relaxed)
    XCTAssertTrue(p.CAS(current: r2, future: r1))
    while !p.loadCAS(current: &j, future: r3) {}
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)
  }

  public func testTaggedOptionalMutableRawPointer()
  {
    let r0 = (UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), 0)
    let r1 = (UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), 1)
    let r2 = (UnsafeMutableRawPointer(bitPattern: UInt.randomPositive()), 2)
    let r3 = (r2.0, r2.1+1)

    var p = AtomicTaggedOptionalMutableRawPointer(r3)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    p.initialize((r3.0, r0.1))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r0.1, p.value.tag)

    p.store(r1, order: .release)
    XCTAssertEqual(r1.0, p.value.pointer)
    XCTAssertEqual(r1.1, p.value.tag)

    var j = p.swap(r2, order: .acqrel)
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    j = p.load(order: .acquire)
    XCTAssertEqual(r2.0, j.0)
    XCTAssertEqual(r2.1, j.1)

    XCTAssertTrue(p.CAS(current: r2, future: r3))
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)

    XCTAssertFalse(p.CAS(current: j, future: r2, type: .weak))
    XCTAssertTrue(p.CAS(current: r3, future: r2))
    j = p.load(order: .relaxed)
    XCTAssertTrue(p.CAS(current: r2, future: r1))
    while !p.loadCAS(current: &j, future: r3) {}
    XCTAssertEqual(r1.0, j.0)
    XCTAssertEqual(r1.1, j.1)
    XCTAssertEqual(r3.0, p.value.pointer)
    XCTAssertEqual(r3.1, p.value.tag)
  }

  public func testBool()
  {
    var boolean = AtomicBool()
    boolean.initialize(false)
    XCTAssertEqual(boolean.value, false)

    boolean.store(false)
    XCTAssertEqual(boolean.value, false)

    boolean.store(true)
    XCTAssertEqual(boolean.value, true)
    XCTAssertEqual(boolean.value, boolean.load())

    boolean.store(true)
    boolean.or(true)
    XCTAssertEqual(boolean.value, true)
    boolean.or(false)
    XCTAssertEqual(boolean.value, true)
    boolean.store(false)
    boolean.or(false)
    XCTAssertEqual(boolean.value, false)
    boolean.or(true)
    XCTAssertEqual(boolean.value, true)

    boolean.and(false)
    XCTAssertEqual(boolean.value, false)
    boolean.and(true)
    XCTAssertEqual(boolean.value, false)

    boolean.xor(false)
    XCTAssertEqual(boolean.value, false)
    boolean.xor(true)
    XCTAssertEqual(boolean.value, true)

    var old = boolean.swap(false)
    XCTAssertEqual(old, true)
    XCTAssertEqual(boolean.swap(true), false)

    boolean.CAS(current: true, future: false)
    XCTAssertEqual(boolean.value, false)

    XCTAssertEqual(boolean.CAS(current: false, future: true, type: .strong), true)
    XCTAssertEqual(boolean.value, old)
    XCTAssertEqual(boolean.loadCAS(current: &old, future: false, type: .strong), true)

    while !boolean.loadCAS(current: &old, future: true, type: .weak) {}
    while !boolean.CAS(current: !old, future: false, type: .weak) {}
  }

  public func testFence()
  {
    threadFence()
    threadFence(order: .sequential)
  }
}
