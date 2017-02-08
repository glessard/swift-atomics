//
//  AtomicsTests.swift
//  AtomicsTests
//
//  Created by Guillaume Lessard on 2015-07-06.
//  Copyright © 2015 Guillaume Lessard. All rights reserved.
//

import XCTest

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import func Darwin.libkern.OSAtomic.OSAtomicCompareAndSwap32
import func Darwin.C.stdlib.arc4random
#else // assuming os(Linux)
import func Glibc.random
import func Glibc.usleep
#endif

import struct Foundation.Date
import Dispatch

import Atomics

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

func nzRandom() -> UInt
{
  // Return a nonzero, positive Int less than (or equal to) Int32.max/2.
  #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    return UInt(arc4random() & 0x3fff_fffe + 1)
  #else
    return UInt(random() & 0x3fff_fffe + 1)
  #endif
}

class AtomicsTests: XCTestCase
{
  static var allTests: [(String, (AtomicsTests) -> () throws -> Void)] {
    return [
      ("testLoad", testLoad),
      ("testStore", testStore),
      ("testSwap", testSwap),
      ("testCAS", testCAS),
      ("testAdd", testAdd),
      ("testSub", testSub),
      ("testIncrement", testIncrement),
      ("testDecrement", testDecrement),
      ("testOr", testOr),
      ("testXor", testXor),
      ("testAnd", testAnd),
      ("testPerformanceRead", testPerformanceRead),
      ("testPerformanceSynchronizedRead", testPerformanceSynchronizedRead),
      ("testPerformanceStore", testPerformanceStore),
      ("testPerformanceSynchronizedStore", testPerformanceSynchronizedStore),
      ("testPerformanceSwiftCASSuccess", testPerformanceSwiftCASSuccess),
      ("testPerformanceSwiftCASFailure", testPerformanceSwiftCASFailure),
      ("testBool", testBool),
      ("testExample", testExample),
    ]
  }

  func testBool()
  {
    var boolean = AtomicBool(false)
    _ = AtomicBool(true)
    XCTAssert(boolean.value == false)

    boolean.store(false)
    XCTAssert(boolean.value == false)

    boolean.store(true)
    XCTAssert(boolean.value == true)
    XCTAssert(boolean.value == boolean.load())

    boolean.store(true)
    boolean.or(true)
    XCTAssert(boolean.value == true)
    boolean.or(false)
    XCTAssert(boolean.value == true)
    boolean.store(false)
    boolean.or(false)
    XCTAssert(boolean.value == false)
    boolean.or(true)
    XCTAssert(boolean.value == true)

    boolean.and(false)
    XCTAssert(boolean.value == false)
    boolean.and(true)
    XCTAssert(boolean.value == false)

    boolean.xor(false)
    XCTAssert(boolean.value == false)
    boolean.xor(true)
    XCTAssert(boolean.value == true)

    let old = boolean.swap(false)
    XCTAssert(old == true)
    XCTAssert(boolean.swap(true) == false)

    boolean.CAS(current: true, future: false)
    if boolean.CAS(current: false, future: true)
    {
      boolean.CAS(current: true, future: false, type: .weak)
      boolean.CAS(current: false, future: true, type: .weak)
    }
  }

  func testLoad()
  {
    var randInt = AtomicInt(Int(nzRandom()))
    let readInt = randInt.load()
    XCTAssert(randInt.value == readInt)

    var randUInt = AtomicUInt(UInt(nzRandom()))
    let readUInt = randUInt.load()
    XCTAssert(randUInt.value == readUInt)

    var randInt32 = AtomicInt32(Int32(nzRandom()))
    let readInt32 = randInt32.load()
    XCTAssert(randInt32.value == readInt32)

    var randUInt32 = AtomicUInt32(UInt32(nzRandom()))
    let readUInt32 = randUInt32.load()
    XCTAssert(randUInt32.value == readUInt32)

    var randInt64 = AtomicInt64(Int64(nzRandom()))
    let readInt64 = randInt64.load()
    XCTAssert(randInt64.value == readInt64)

    var randUInt64 = AtomicUInt64(UInt64(nzRandom()))
    let readUInt64 = randUInt64.load()
    XCTAssert(randUInt64.value == readUInt64)

    var randRPtr = AtomicRawPointer(UnsafeRawPointer(bitPattern: nzRandom()))
    let readRPtr = randRPtr.load()
    XCTAssert(randRPtr.pointer == readRPtr)

    var randMRPtr = AtomicMutableRawPointer(UnsafeMutableRawPointer(bitPattern: nzRandom()))
    let readMRPtr = randMRPtr.load()
    XCTAssert(randMRPtr.pointer == readMRPtr)

    var randPtr = AtomicPointer<Point>(UnsafePointer(bitPattern: nzRandom()))
    let readPtr = randPtr.load()
    XCTAssert(randPtr.pointer == readPtr)
    randPtr = AtomicPointer(nil)
    XCTAssert(randPtr.load() == nil)

    var randMutPtr = AtomicMutablePointer<Point>(UnsafeMutablePointer(bitPattern: nzRandom()))
    let readMutPtr = randMutPtr.load()
    XCTAssert(randMutPtr.pointer == readMutPtr)
    randMutPtr = AtomicMutablePointer(nil)
    XCTAssert(randMutPtr.load() == nil)

    var randOPtr = AtomicOpaquePointer(OpaquePointer(bitPattern: nzRandom()))
    let readOPtr = randOPtr.load()
    XCTAssert(randOPtr.pointer == readOPtr)
  }


  func testStore()
  {
    let randInt = Int(nzRandom())
    var storInt = AtomicInt(Int(nzRandom()))
    storInt.store(randInt)
    XCTAssert(randInt == storInt.value)

    let randUInt = UInt(nzRandom())
    var storUInt = AtomicUInt(UInt(nzRandom()))
    storUInt.store(randUInt)
    XCTAssert(randUInt == storUInt.value)

    let randInt32 = Int32(nzRandom())
    var storInt32 = AtomicInt32(Int32(nzRandom()))
    storInt32.store(randInt32)
    XCTAssert(randInt32 == storInt32.value)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = AtomicUInt32(UInt32(nzRandom()))
    storUInt32.store(randUInt32)
    XCTAssert(randUInt32 == storUInt32.value)

    let randInt64 = Int64(nzRandom())
    var storInt64 = AtomicInt64(Int64(nzRandom()))
    storInt64.store(randInt64)
    XCTAssert(randInt64 == storInt64.value)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = AtomicUInt64(UInt64(nzRandom()))
    storUInt64.store(randUInt64)
    XCTAssert(randUInt64 == storUInt64.value)

    let randRPtr = UnsafeRawPointer(bitPattern: nzRandom())
    var storRPtr = AtomicRawPointer()
    storRPtr.store(randRPtr)
    XCTAssert(randRPtr == storRPtr.pointer)

    let randMRPtr = UnsafeMutableRawPointer(bitPattern: nzRandom())
    var storMRPtr = AtomicMutableRawPointer()
    storMRPtr.store(randMRPtr)
    XCTAssert(storMRPtr.pointer == randMRPtr)
  
    let randPtr = UnsafePointer<Point>(bitPattern: nzRandom())
    var storPtr = AtomicPointer(UnsafePointer<Point>(bitPattern: nzRandom()))
    storPtr.store(randPtr)
    XCTAssert(randPtr == storPtr.pointer)

    let randMutPtr = UnsafeMutablePointer<Point>(bitPattern: nzRandom())
    var storMutPtr = AtomicMutablePointer(UnsafeMutablePointer<Point>(bitPattern: nzRandom()))
    storMutPtr.store(randMutPtr)
    XCTAssert(randMutPtr == storMutPtr.pointer)

    let randOPtr = OpaquePointer(bitPattern: nzRandom())
    var storOPtr = AtomicOpaquePointer(OpaquePointer(bitPattern: nzRandom()))
    storOPtr.store(randOPtr)
    XCTAssert(randOPtr == storOPtr.pointer)
  }


  func testSwap()
  {
    let randInt = Int(nzRandom())
    var storInt = AtomicInt(Int(nzRandom()))
    let readInt = storInt.swap(randInt)
    XCTAssert(readInt != randInt)
    XCTAssert(randInt == storInt.value)

    let randUInt = UInt(nzRandom())
    var storUInt = AtomicUInt(UInt(nzRandom()))
    let readUInt = storUInt.swap(randUInt)
    XCTAssert(readUInt != randUInt)
    XCTAssert(randUInt == storUInt.value)

    let randInt32 = Int32(nzRandom())
    var storInt32 = AtomicInt32(Int32(nzRandom()))
    let readInt32 = storInt32.swap(randInt32)
    XCTAssert(readInt32 != randInt32)
    XCTAssert(randInt32 == storInt32.value)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = AtomicUInt32(UInt32(nzRandom()))
    let readUInt32 = storUInt32.swap(randUInt32)
    XCTAssert(readUInt32 != randUInt32)
    XCTAssert(randUInt32 == storUInt32.value)

    let randInt64 = Int64(nzRandom())
    var storInt64 = AtomicInt64(Int64(nzRandom()))
    let readInt64 = storInt64.swap(randInt64)
    XCTAssert(readInt64 != randInt64)
    XCTAssert(randInt64 == storInt64.value)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = AtomicUInt64(UInt64(nzRandom()))
    let readUInt64 = storUInt64.swap(randUInt64)
    XCTAssert(readUInt64 != randUInt64)
    XCTAssert(randUInt64 == storUInt64.value)

    let randRPtr = UnsafeRawPointer(bitPattern: nzRandom())
    var storRPtr = AtomicRawPointer()
    let readRPtr = storRPtr.swap(randRPtr)
    XCTAssert(readRPtr != randRPtr)
    XCTAssert(randRPtr == storRPtr.pointer)
    _ = storRPtr.swap(nil)
    XCTAssert(storRPtr.swap(randRPtr) == nil)

    let randMRPtr = UnsafeMutableRawPointer(bitPattern: nzRandom())
    var storMRPtr = AtomicMutableRawPointer()
    let readMRPtr = storMRPtr.swap(randMRPtr)
    XCTAssert(readMRPtr != randMRPtr)
    XCTAssert(randMRPtr == storMRPtr.pointer)
    _ = storMRPtr.swap(nil)
    XCTAssert(storMRPtr.swap(randMRPtr) == nil)

    let randPtr = UnsafePointer<Point>(bitPattern: nzRandom())
    var storPtr = AtomicPointer(UnsafePointer<Point>(bitPattern: nzRandom()))
    let readPtr = storPtr.swap(randPtr)
    XCTAssert(readPtr != randPtr)
    XCTAssert(randPtr == storPtr.pointer)
    _ = storPtr.swap(nil)
    XCTAssert(storPtr.swap(randPtr) == nil)

    let randMutPtr = UnsafeMutablePointer<Point>(bitPattern: nzRandom())
    var storMutPtr = AtomicMutablePointer(UnsafeMutablePointer<Point>(bitPattern: nzRandom()))
    let readMutPtr = storMutPtr.swap(randMutPtr)
    XCTAssert(readMutPtr != randMutPtr)
    XCTAssert(randMutPtr == storMutPtr.pointer)
    _ = storMutPtr.swap(nil)
    XCTAssert(storMutPtr.swap(randMutPtr) == nil)

    let randOPtr = OpaquePointer(bitPattern: nzRandom())
    var storOPtr = AtomicOpaquePointer(OpaquePointer(bitPattern: nzRandom()))
    let readOPtr = storOPtr.swap(randOPtr)
    XCTAssert(readOPtr != randOPtr)
    XCTAssert(randOPtr == storOPtr.pointer)
    _ = storOPtr.swap(nil)
    XCTAssert(storOPtr.swap(randOPtr) == nil)
  }

  func testAdd()
  {
    let fInt = Int(nzRandom())
    let sInt = Int(nzRandom())
    var rInt = AtomicInt(sInt)
    XCTAssert(rInt.add(fInt) == sInt)
    XCTAssert(rInt.value == fInt+sInt)

    let fUInt = UInt(nzRandom())
    let sUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(sUInt)
    XCTAssert(rUInt.add(fUInt) == sUInt)
    XCTAssert(rUInt.value == fUInt+sUInt)

    let fInt32 = Int32(nzRandom())
    let sInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(sInt32)
    XCTAssert(rInt32.add(fInt32) == sInt32)
    XCTAssert(rInt32.value == fInt32+sInt32)

    let fUInt32 = UInt32(nzRandom())
    let sUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(sUInt32)
    XCTAssert(rUInt32.add(fUInt32) == sUInt32)
    XCTAssert(rUInt32.value == fUInt32+sUInt32)

    let fInt64 = Int64(nzRandom())
    let sInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(sInt64)
    XCTAssert(rInt64.add(fInt64) == sInt64)
    XCTAssert(rInt64.value == fInt64+sInt64)

    let fUInt64 = UInt64(nzRandom())
    let sUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(sUInt64)
    XCTAssert(rUInt64.add(fUInt64) == sUInt64)
    XCTAssert(rUInt64.value == fUInt64+sUInt64)
  }

  func testSub()
  {
    let fInt = Int(nzRandom())
    var rInt = AtomicInt(fInt)
    XCTAssert(rInt.subtract(1) == fInt)
    XCTAssert(rInt.value == fInt-1)

    let fUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(fUInt)
    XCTAssert(rUInt.subtract(1) == fUInt)
    XCTAssert(rUInt.value == fUInt-1)

    let fInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(fInt32)
    XCTAssert(rInt32.subtract(1) == fInt32)
    XCTAssert(rInt32.value == fInt32-1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(fUInt32)
    XCTAssert(rUInt32.subtract(1) == fUInt32)
    XCTAssert(rUInt32.value == fUInt32-1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(fInt64)
    XCTAssert(rInt64.subtract(1) == fInt64)
    XCTAssert(rInt64.value == fInt64-1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(fUInt64)
    XCTAssert(rUInt64.subtract(1) == fUInt64)
    XCTAssert(rUInt64.value == fUInt64-1)
  }

  func testOr()
  {
    let fInt = Int(nzRandom())
    let sInt = Int(nzRandom())
    var rInt = AtomicInt(sInt)
    XCTAssert(rInt.bitwiseOr(fInt) == sInt)
    XCTAssert(rInt.value == fInt|sInt)

    let fUInt = UInt(nzRandom())
    let sUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(sUInt)
    XCTAssert(rUInt.bitwiseOr(fUInt) == sUInt)
    XCTAssert(rUInt.value == fUInt|sUInt)

    let fInt32 = Int32(nzRandom())
    let sInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(sInt32)
    XCTAssert(rInt32.bitwiseOr(fInt32) == sInt32)
    XCTAssert(rInt32.value == fInt32|sInt32)

    let fUInt32 = UInt32(nzRandom())
    let sUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(sUInt32)
    XCTAssert(rUInt32.bitwiseOr(fUInt32) == sUInt32)
    XCTAssert(rUInt32.value == fUInt32|sUInt32)

    let fInt64 = Int64(nzRandom())
    let sInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(sInt64)
    XCTAssert(rInt64.bitwiseOr(fInt64) == sInt64)
    XCTAssert(rInt64.value == fInt64|sInt64)

    let fUInt64 = UInt64(nzRandom())
    let sUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(sUInt64)
    XCTAssert(rUInt64.bitwiseOr(fUInt64) == sUInt64)
    XCTAssert(rUInt64.value == fUInt64|sUInt64)
  }

  func testXor()
  {
    let fInt = Int(nzRandom())
    let sInt = Int(nzRandom())
    var rInt = AtomicInt(sInt)
    XCTAssert(rInt.bitwiseXor(fInt) == sInt)
    XCTAssert(rInt.value == fInt^sInt)

    let fUInt = UInt(nzRandom())
    let sUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(sUInt)
    XCTAssert(rUInt.bitwiseXor(fUInt) == sUInt)
    XCTAssert(rUInt.value == fUInt^sUInt)

    let fInt32 = Int32(nzRandom())
    let sInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(sInt32)
    XCTAssert(rInt32.bitwiseXor(fInt32) == sInt32)
    XCTAssert(rInt32.value == fInt32^sInt32)

    let fUInt32 = UInt32(nzRandom())
    let sUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(sUInt32)
    XCTAssert(rUInt32.bitwiseXor(fUInt32) == sUInt32)
    XCTAssert(rUInt32.value == fUInt32^sUInt32)

    let fInt64 = Int64(nzRandom())
    let sInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(sInt64)
    XCTAssert(rInt64.bitwiseXor(fInt64) == sInt64)
    XCTAssert(rInt64.value == fInt64^sInt64)

    let fUInt64 = UInt64(nzRandom())
    let sUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(sUInt64)
    XCTAssert(rUInt64.bitwiseXor(fUInt64) == sUInt64)
    XCTAssert(rUInt64.value == fUInt64^sUInt64)
  }

  func testAnd()
  {
    let fInt = Int(nzRandom())
    let sInt = Int(nzRandom())
    var rInt = AtomicInt(sInt)
    XCTAssert(rInt.bitwiseAnd(fInt) == sInt)
    XCTAssert(rInt.value == fInt&sInt)

    let fUInt = UInt(nzRandom())
    let sUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(sUInt)
    XCTAssert(rUInt.bitwiseAnd(fUInt) == sUInt)
    XCTAssert(rUInt.value == fUInt&sUInt)

    let fInt32 = Int32(nzRandom())
    let sInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(sInt32)
    XCTAssert(rInt32.bitwiseAnd(fInt32) == sInt32)
    XCTAssert(rInt32.value == fInt32&sInt32)

    let fUInt32 = UInt32(nzRandom())
    let sUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(sUInt32)
    XCTAssert(rUInt32.bitwiseAnd(fUInt32) == sUInt32)
    XCTAssert(rUInt32.value == fUInt32&sUInt32)

    let fInt64 = Int64(nzRandom())
    let sInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(sInt64)
    XCTAssert(rInt64.bitwiseAnd(fInt64) == sInt64)
    XCTAssert(rInt64.value == fInt64&sInt64)

    let fUInt64 = UInt64(nzRandom())
    let sUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(sUInt64)
    XCTAssert(rUInt64.bitwiseAnd(fUInt64) == sUInt64)
    XCTAssert(rUInt64.value == fUInt64&sUInt64)
  }

  func testIncrement()
  {
    let fInt = Int(nzRandom())
    var rInt = AtomicInt(fInt)
    XCTAssert(rInt.increment() == fInt)
    XCTAssert(rInt.value == fInt+1)

    let fUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(fUInt)
    XCTAssert(rUInt.increment() == fUInt)
    XCTAssert(rUInt.value == fUInt+1)

    let fInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(fInt32)
    XCTAssert(rInt32.increment() == fInt32)
    XCTAssert(rInt32.value == fInt32+1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(fUInt32)
    XCTAssert(rUInt32.increment() == fUInt32)
    XCTAssert(rUInt32.value == fUInt32+1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(fInt64)
    XCTAssert(rInt64.increment() == fInt64)
    XCTAssert(rInt64.value == fInt64+1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(fUInt64)
    XCTAssert(rUInt64.increment() == fUInt64)
    XCTAssert(rUInt64.value == fUInt64+1)
  }

  func testDecrement()
  {
    let fInt = Int(nzRandom())
    var rInt = AtomicInt(fInt)
    XCTAssert(rInt.decrement() == fInt)
    XCTAssert(rInt.value == fInt-1)

    let fUInt = UInt(nzRandom())
    var rUInt = AtomicUInt(fUInt)
    XCTAssert(rUInt.decrement() == fUInt)
    XCTAssert(rUInt.value == fUInt-1)

    let fInt32 = Int32(nzRandom())
    var rInt32 = AtomicInt32(fInt32)
    XCTAssert(rInt32.decrement() == fInt32)
    XCTAssert(rInt32.value == fInt32-1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = AtomicUInt32(fUInt32)
    XCTAssert(rUInt32.decrement() == fUInt32)
    XCTAssert(rUInt32.value == fUInt32-1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = AtomicInt64(fInt64)
    XCTAssert(rInt64.decrement() == fInt64)
    XCTAssert(rInt64.value == fInt64-1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = AtomicUInt64(fUInt64)
    XCTAssert(rUInt64.decrement() == fUInt64)
    XCTAssert(rUInt64.value == fUInt64-1)
  }

  func testCAS()
  {
    var randInt = AtomicInt(Int(nzRandom()))
    let storInt = Int(nzRandom())
    XCTAssert(randInt.CAS(current: 0, future: randInt.value) == false)
    XCTAssert(randInt.CAS(current: randInt.value, future: storInt, type: .weak))
    XCTAssert(randInt.value == storInt)

    var randUInt = AtomicUInt(UInt(nzRandom()))
    let storUInt = UInt(nzRandom())
    XCTAssert(randUInt.CAS(current: 0, future: randUInt.value) == false)
    XCTAssert(randUInt.CAS(current: randUInt.value, future: storUInt, type: .weak))
    XCTAssert(randUInt.value == storUInt)

    var randInt32 = AtomicInt32(Int32(nzRandom()))
    let storInt32 = Int32(nzRandom())
    XCTAssert(randInt32.CAS(current: 0, future: randInt32.value) == false)
    XCTAssert(randInt32.CAS(current: randInt32.value, future: storInt32, type: .weak))
    XCTAssert(randInt32.value == storInt32)

    var randUInt32 = AtomicUInt32(UInt32(nzRandom()))
    let storUInt32 = UInt32(nzRandom())
    XCTAssert(randUInt32.CAS(current: 0, future: randUInt32.value) == false)
    XCTAssert(randUInt32.CAS(current: randUInt32.value, future: storUInt32, type: .weak))
    XCTAssert(randUInt32.value == storUInt32)

    var randInt64 = AtomicInt64(Int64(nzRandom()))
    let storInt64 = Int64(nzRandom())
    XCTAssert(randInt64.CAS(current: 0, future: randInt64.value) == false)
    XCTAssert(randInt64.CAS(current: randInt64.value, future: storInt64, type: .weak))
    XCTAssert(randInt64.value == storInt64)

    var randUInt64 = AtomicUInt64(UInt64(nzRandom()))
    let storUInt64 = UInt64(nzRandom())
    XCTAssert(randUInt64.CAS(current: 0, future: randUInt64.value) == false)
    XCTAssert(randUInt64.CAS(current: randUInt64.value, future: storUInt64, type: .weak))
    XCTAssert(randUInt64.value == storUInt64)

    var randRPtr = AtomicRawPointer(UnsafeRawPointer(bitPattern: nzRandom()))
    let storRPtr = UnsafeRawPointer(bitPattern: nzRandom())
    XCTAssert(randRPtr.CAS(current: nil, future: randRPtr.pointer) == false)
    XCTAssert(randRPtr.CAS(current: randRPtr.pointer, future: storRPtr, type: .weak))
    XCTAssert(randRPtr.pointer == storRPtr)

    var randMRPtr = AtomicMutableRawPointer(UnsafeMutableRawPointer(bitPattern: nzRandom()))
    let storMRPtr = UnsafeMutableRawPointer(bitPattern: nzRandom())
    XCTAssert(randMRPtr.CAS(current: nil, future: randMRPtr.pointer) == false)
    XCTAssert(randMRPtr.CAS(current: randMRPtr.pointer, future: storMRPtr, type: .weak))
    XCTAssert(randMRPtr.pointer == storMRPtr)

    var randPtr = AtomicPointer(UnsafePointer<Point>(bitPattern: nzRandom()))
    let storPtr = UnsafePointer<Point>(bitPattern: nzRandom())
    XCTAssert(randPtr.CAS(current: nil, future: randPtr.pointer) == false)
    XCTAssert(randPtr.CAS(current: randPtr.pointer, future: storPtr, type: .weak))
    XCTAssert(randPtr.pointer == storPtr)

    var randMutPtr = AtomicMutablePointer(UnsafeMutablePointer<Point>(bitPattern: nzRandom()))
    let storMutPtr = UnsafeMutablePointer<Point>(bitPattern: nzRandom())
    XCTAssert(randMutPtr.CAS(current: nil, future: randMutPtr.pointer) == false)
    XCTAssert(randMutPtr.CAS(current: randMutPtr.pointer, future: storMutPtr, type: .weak))
    XCTAssert(randMutPtr.pointer == storMutPtr)

    var randOPtr = AtomicOpaquePointer(OpaquePointer(bitPattern: nzRandom()))
    let storOPtr = OpaquePointer(bitPattern: nzRandom())
    XCTAssert(randOPtr.CAS(current: nil, future: randOPtr.pointer) == false)
    XCTAssert(randOPtr.CAS(current: randOPtr.pointer, future: storOPtr, type: .weak))
    XCTAssert(randOPtr.pointer == storOPtr)
  }

  let testLoopCount = 1_000_000

  func testPerformanceStore()
  {
    var m = AtomicInt(0)
    measure {
      m.store(0)
      for i in 0..<1_000_000 { m.store(i, order: .relaxed) }
    }
  }

  func testPerformanceSynchronizedStore()
  {
    var m = AtomicInt(0)
    measure {
      m.store(0)
      for i in 0..<1_000_000 { m.store(i, order: .sequential) }
    }
  }

  func testPerformanceRead()
  {
    var m = AtomicInt(0)
    measure {
      m.store(0)
      for _ in 0..<1_000_000 { _ = m.load(order: .relaxed) }
    }
  }

  func testPerformanceSynchronizedRead()
  {
    var m = AtomicInt(0)
    measure {
      m.store(0)
      for _ in 0..<1_000_000 { _ = m.load(order: .sequential) }
    }
  }

  func testPerformanceSwiftCASSuccess()
  {
    let c = Int32(testLoopCount)
    var m = AtomicInt32(0)
    measure {
      m.store(0)
      for i in (m.value)..<c { m.CAS(current: i, future: i+1) }
    }
  }

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
  func testPerformanceOSAtomicCASSuccess()
  {
    let c = Int32(testLoopCount)
    var m = Int32(0)
    measure {
      m = 0
      for i in m..<c { OSAtomicCompareAndSwap32(i, i+1, &m) }
    }
  }
#endif

  func testPerformanceSwiftCASFailure()
  {
    var m = AtomicInt32(0)
    measure {
      m.store(0)
      for i in (m.value)..<1_000_000 { m.CAS(current: i, future: 0) }
    }
  }

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
  func testPerformanceOSAtomicCASFailure()
  {
    var m = Int32(0)
    measure {
      m = 0
      for i in m..<1_000_000 { OSAtomicCompareAndSwap32(i, 0, &m) }
    }
  }
#endif

  private struct TestStruct
  {
    var a = AtomicInt(0)
    var b = AtomicInt(1)
    var c = AtomicInt(2)
    var d = AtomicInt(3)

    mutating func print()
    {
      Swift.print("\(a.value) \(b.value) \(c.value) \(d.value)")
    }
  }

  func testExample()
  {
    var value = AtomicInt(0)

    print(value.swap(1))
    print(value.value)
    value.store(2)
    print(value.value)
    print("")

    var p = AtomicMutablePointer(UnsafeMutablePointer<Int>.allocate(capacity: 1))
    print(p.pointer!)

    var q = AtomicMutablePointer(p.load())
    let r = q.swap(UnsafeMutablePointer<Int>.allocate(capacity: 1))
    p.store(q.pointer)

    print(q.pointer!)
    print(r!)
    print(p.pointer!)
    print("")

    var pp = AtomicPointer<Int>(UnsafeMutablePointer<Int>.allocate(capacity: 1))

    print(pp.pointer!)

    var qq = AtomicPointer(pp.load())
    let rr = qq.swap(UnsafePointer(UnsafeMutablePointer<Int>.allocate(capacity: 1)))
    pp.store(qq.pointer)

    print(qq.pointer!)
    print(rr!)
    print(pp.pointer!)
    print("")

    var i = AtomicInt32(Int32(nzRandom()))
    print(i.value)

    var j = AtomicInt32(i.load())
    let k = j.swap(Int32(nzRandom()))
    i.store(j.value)

    print(j.value)
    print(k)
    print(i.value)
    print("")

    var ii = AtomicInt64(Int64(nzRandom()))
    print(ii.value)

    var jj = AtomicInt64(ii.load())
    let kk = jj.swap(numericCast(nzRandom()))
    ii.store(jj.value)

    print(jj.value)
    print(kk)
    print(ii.value)
    print("")

    var start = Date()
    var dt = Date().timeIntervalSince(start)
    let iterations = 1_000_000

    start = Date()
    for _ in 1...iterations
    {
      value.store(numericCast(nzRandom()))
    }
    dt = Date().timeIntervalSince(start)
    print(Int(1e9*dt/Double(iterations)))

    start = Date()
    for _ in 1...iterations
    {
      value.store(numericCast(nzRandom()))
    }
    dt = Date().timeIntervalSince(start)
    print(Int(1e9*dt/Double(iterations)))

    start = Date()
    for _ in 1...iterations
    {
      value.store(numericCast(nzRandom()))
    }
    dt = Date().timeIntervalSince(start)
    print(Int(1e9*dt/Double(iterations)))
    print("")

    var t = TestStruct()
    t.print()

    t.c.store(4)

    let g = DispatchGroup()
    DispatchQueue.global().async(group: g) {
      t.print()
      let v = t.a.swap(5)
      usleep(1000)
      t.b.store(v, order: .sequential)
    }

    usleep(500)
    t.print()
    g.wait()
    t.print()

    print("")
    let pt = UnsafeMutablePointer<TestStruct>.allocate(capacity: 1)
    pt.pointee = TestStruct()
    pt.pointee.print()

    pt.pointee.c.store(4)

    DispatchQueue.global().async(group: g) {
      pt.pointee.print()
      let v = pt.pointee.a.swap(5)
      usleep(1000)
      pt.pointee.b.store(v, order: .sequential)
    }

    usleep(500)
    pt.pointee.print()
    g.wait()
    pt.pointee.print()

    pt.deallocate(capacity: 1)
  }
}
