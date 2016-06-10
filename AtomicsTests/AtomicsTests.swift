//
//  AtomicsTests.swift
//  AtomicsTests
//
//  Created by Guillaume Lessard on 2015-07-06.
//  Copyright © 2015 Guillaume Lessard. All rights reserved.
//

import XCTest

import Darwin.libkern.OSAtomic

import Atomics

class AtomicsTests: XCTestCase
{
  func nzRandom() -> UInt
  {
    // Return a positive Int less than (or equal to) Int32.max/2.
    return UInt(arc4random() & 0x3fff_fffe + 1)
  }

  func testRead()
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

    var randPtr = AtomicPointer<CGPoint>(UnsafePointer(bitPattern: nzRandom()))
    let readPtr = randPtr.load()
    XCTAssert(randPtr.pointer == readPtr)

    var randMutPtr = AtomicMutablePointer<CGPoint>(UnsafeMutablePointer(bitPattern: nzRandom()))
    let readMutPtr = randMutPtr.load()
    XCTAssert(randMutPtr.pointer == readMutPtr)

    var randOPtr = AtomicOpaquePointer(COpaquePointer(bitPattern: nzRandom()))
    let readOPtr = randOPtr.load()
    XCTAssert(randOPtr.pointer == readOPtr)
  }

    
  func testSyncRead()
  {
    var randInt = AtomicInt(Int(nzRandom()))
    let readInt = randInt.load(.sequential)
    XCTAssert(randInt.value == readInt)

    var randUInt = AtomicUInt(UInt(nzRandom()))
    let readUInt = randUInt.load(.sequential)
    XCTAssert(randUInt.value == readUInt)

    var randInt32 = AtomicInt32(Int32(nzRandom()))
    let readInt32 = randInt32.load(.sequential)
    XCTAssert(randInt32.value == readInt32)

    var randUInt32 = AtomicUInt32(UInt32(nzRandom()))
    let readUInt32 = randUInt32.load(.sequential)
    XCTAssert(randUInt32.value == readUInt32)

    var randInt64 = AtomicInt64(Int64(nzRandom()))
    let readInt64 = randInt64.load(.sequential)
    XCTAssert(randInt64.value == readInt64)

    var randUInt64 = AtomicUInt64(UInt64(nzRandom()))
    let readUInt64 = randUInt64.load(.sequential)
    XCTAssert(randUInt64.value == readUInt64)

    var randPtr = AtomicPointer<CGPoint>(UnsafePointer(bitPattern: nzRandom()))
    let readPtr = randPtr.load(.sequential)
    XCTAssert(randPtr.pointer == readPtr)

    var randMutPtr = AtomicMutablePointer<CGPoint>(UnsafeMutablePointer(bitPattern: nzRandom()))
    let readMutPtr = randMutPtr.load(.sequential)
    XCTAssert(randMutPtr.pointer == readMutPtr)

    var randOPtr = AtomicOpaquePointer(COpaquePointer(bitPattern: nzRandom()))
    let readOPtr = randOPtr.load(.sequential)
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

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = AtomicPointer(UnsafePointer<CGPoint>(bitPattern: nzRandom()))
    storPtr.store(randPtr)
    XCTAssert(randPtr == storPtr.pointer)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = AtomicMutablePointer(UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom()))
    storMutPtr.store(randMutPtr)
    XCTAssert(randMutPtr == storMutPtr.pointer)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = AtomicOpaquePointer(COpaquePointer(bitPattern: nzRandom()))
    storOPtr.store(randOPtr)
    XCTAssert(randOPtr == storOPtr.pointer)
  }
  
  
  func testSyncStore()
  {
    let randInt = Int(nzRandom())
    var storInt = AtomicInt(Int(nzRandom()))
    storInt.store(randInt, order: .sequential)
    XCTAssert(randInt == storInt.value)

    let randUInt = UInt(nzRandom())
    var storUInt = AtomicUInt(UInt(nzRandom()))
    storUInt.store(randUInt, order: .sequential)
    XCTAssert(randUInt == storUInt.value)

    let randInt32 = Int32(nzRandom())
    var storInt32 = AtomicInt32(Int32(nzRandom()))
    storInt32.store(randInt32, order: .sequential)
    XCTAssert(randInt32 == storInt32.value)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = AtomicUInt32(UInt32(nzRandom()))
    storUInt32.store(randUInt32, order: .sequential)
    XCTAssert(randUInt32 == storUInt32.value)

    let randInt64 = Int64(nzRandom())
    var storInt64 = AtomicInt64(Int64(nzRandom()))
    storInt64.store(randInt64, order: .sequential)
    XCTAssert(randInt64 == storInt64.value)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = AtomicUInt64(UInt64(nzRandom()))
    storUInt64.store(randUInt64, order: .sequential)
    XCTAssert(randUInt64 == storUInt64.value)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = AtomicPointer(UnsafePointer<CGPoint>(bitPattern: nzRandom()))
    storPtr.store(randPtr, order: .sequential)
    XCTAssert(randPtr == storPtr.pointer)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = AtomicMutablePointer(UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom()))
    storMutPtr.store(randMutPtr, order: .sequential)
    XCTAssert(randMutPtr == storMutPtr.pointer)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = AtomicOpaquePointer(COpaquePointer(bitPattern: nzRandom()))
    storOPtr.store(randOPtr, order: .sequential)
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

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = AtomicPointer(UnsafePointer<CGPoint>(bitPattern: nzRandom()))
    let readPtr = storPtr.swap(randPtr)
    XCTAssert(readPtr != randPtr)
    XCTAssert(randPtr == storPtr.pointer)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = AtomicMutablePointer(UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom()))
    let readMutPtr = storMutPtr.swap(randMutPtr)
    XCTAssert(readMutPtr != randMutPtr)
    XCTAssert(randMutPtr == storMutPtr.pointer)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = AtomicOpaquePointer(COpaquePointer(bitPattern: nzRandom()))
    let readOPtr = storOPtr.swap(randOPtr)
    XCTAssert(readOPtr != randOPtr)
    XCTAssert(randOPtr == storOPtr.pointer)
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
    XCTAssert(randInt.CAS(current: randInt.value, future: storInt))
    XCTAssert(randInt.value == storInt)

    var randUInt = AtomicUInt(UInt(nzRandom()))
    let storUInt = UInt(nzRandom())
    XCTAssert(randUInt.CAS(current: 0, future: randUInt.value) == false)
    XCTAssert(randUInt.CAS(current: randUInt.value, future: storUInt))
    XCTAssert(randUInt.value == storUInt)

    var randInt32 = AtomicInt32(Int32(nzRandom()))
    let storInt32 = Int32(nzRandom())
    XCTAssert(randInt32.CAS(current: 0, future: randInt32.value) == false)
    XCTAssert(randInt32.CAS(current: randInt32.value, future: storInt32))
    XCTAssert(randInt32.value == storInt32)

    var randUInt32 = AtomicUInt32(UInt32(nzRandom()))
    let storUInt32 = UInt32(nzRandom())
    XCTAssert(randUInt32.CAS(current: 0, future: randUInt32.value) == false)
    XCTAssert(randUInt32.CAS(current: randUInt32.value, future: storUInt32))
    XCTAssert(randUInt32.value == storUInt32)

    var randInt64 = AtomicInt64(Int64(nzRandom()))
    let storInt64 = Int64(nzRandom())
    XCTAssert(randInt64.CAS(current: 0, future: randInt64.value) == false)
    XCTAssert(randInt64.CAS(current: randInt64.value, future: storInt64))
    XCTAssert(randInt64.value == storInt64)

    var randUInt64 = AtomicUInt64(UInt64(nzRandom()))
    let storUInt64 = UInt64(nzRandom())
    XCTAssert(randUInt64.CAS(current: 0, future: randUInt64.value) == false)
    XCTAssert(randUInt64.CAS(current: randUInt64.value, future: storUInt64))
    XCTAssert(randUInt64.value == storUInt64)

    var randPtr = AtomicPointer(UnsafePointer<CGPoint>(bitPattern: nzRandom()))
    let storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    XCTAssert(randPtr.CAS(current: nil, future: randPtr.pointer) == false)
    XCTAssert(randPtr.CAS(current: randPtr.pointer, future: storPtr))
    XCTAssert(randPtr.pointer == storPtr)

    var randMutPtr = AtomicMutablePointer(UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom()))
    let storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    XCTAssert(randMutPtr.CAS(current: nil, future: randMutPtr.pointer) == false)
    XCTAssert(randMutPtr.CAS(current: randMutPtr.pointer, future: storMutPtr))
    XCTAssert(randMutPtr.pointer == storMutPtr)

    var randOPtr = AtomicOpaquePointer(COpaquePointer(bitPattern: nzRandom()))
    let storOPtr = COpaquePointer(bitPattern: nzRandom())
    XCTAssert(randOPtr.CAS(current: nil, future: randOPtr.pointer) == false)
    XCTAssert(randOPtr.CAS(current: randOPtr.pointer, future: storOPtr))
    XCTAssert(randOPtr.pointer == storOPtr)
  }

  func testPerformanceStore()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.store(0)
      for i in 0..<1_000_000 { m.store(i, order: .relaxed) }
    }
  }
  
  func testPerformanceSynchronizedStore()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.store(0)
      for i in 0..<1_000_000 { m.store(i, order: .sequential) }
    }
  }

  func testPerformanceRead()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.store(0)
      for i in 0..<1_000_000
      {
        m.store(i)
        guard m.load(.relaxed) == i else { XCTFail(); break }
      }
    }
  }

  func testPerformanceSynchronizedRead()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.store(0)
      for i in 0..<1_000_000
      {
        m.store(i)
        guard m.load(.sequential) == i else { XCTFail(); break }
      }
    }
  }

  func testPerformanceSwiftCASSuccess()
  {
    var m = AtomicInt32(0)
    measureBlock {
      m.store(0)
      for i in (m.value)..<1_000_000 { m.CAS(current: m.value, future: i) }
    }
  }

  func testPerformanceOSAtomicCASSuccess()
  {
    var m = Int32(0)
    measureBlock {
      m = 0
      for i in m..<1_000_000 { OSAtomicCompareAndSwap32(m, i, &m) }
    }
  }

  func testPerformanceSwiftCASFailure()
  {
    var m = AtomicInt32(0)
    measureBlock {
      m.store(0)
      for i in (m.value)..<1_000_000 { m.CAS(current: i, future: 0) }
    }
  }

  func testPerformanceOSAtomicCASFailure()
  {
    var m = Int32(0)
    measureBlock {
      m = 0
      for i in m..<1_000_000 { OSAtomicCompareAndSwap32(i, 0, &m) }
    }
  }
  
  private struct TestStruct: CustomStringConvertible
  {
    var a: AtomicInt = 0
    var b: AtomicInt = 1
    var c: AtomicInt = 2
    var d: AtomicInt = 3

    var description: String { return "\(a) \(b) \(c) \(d)" }
  }

  func testExample()
  {
    var value = AtomicInt(0)

    print(value.swap(1))
    print(value)
    value.store(2)
    print(value)

    var p = AtomicMutablePointer(UnsafeMutablePointer<Int>.alloc(1))

    print(p)

    var q = AtomicMutablePointer(p.load())
    let r = q.swap(UnsafeMutablePointer<Int>.alloc(1))
    p.store(q.pointer)

    print(q)
    print(r)
    print(p)
    print("")

    var pp = AtomicPointer<Int>(UnsafeMutablePointer<Int>.alloc(1))

    print(pp)

    var qq = AtomicPointer(pp.load())
    let rr = qq.swap(UnsafePointer(UnsafeMutablePointer<Int>.alloc(1)))
    pp.store(qq.pointer)

    print(qq)
    print(rr)
    print(pp)
    print("")

    var i = AtomicInt32(Int32(nzRandom()))

    print(i)

    var j = AtomicInt32(i.load())
    let k = j.swap(Int32(nzRandom()))
    i.store(j.value)

    print(j)
    print(k)
    print(i)
    print("")

    var ii = AtomicInt64(Int64(nzRandom()))

    print(ii)

    var jj = AtomicInt64(ii.load())
    let kk = jj.swap(numericCast(nzRandom()))
    ii.store(jj.value)

    print(jj)
    print(kk)
    print(ii)
    print("")

    var start = mach_absolute_time()
    var dt = mach_absolute_time()
    let iterations = 1_000_000

    start = mach_absolute_time()
    for _ in 1...iterations
    {
      value.store(random())
    }
    dt = mach_absolute_time() - start
    print(dt/numericCast(iterations))

    start = mach_absolute_time()
    for _ in 1...iterations
    {
      value.store(random())
    }
    dt = mach_absolute_time() - start
    print(dt/numericCast(iterations))

    start = mach_absolute_time()
    for _ in 1...iterations
    {
      value.store(random())
    }
    dt = mach_absolute_time() - start
    print(dt/numericCast(iterations))

    var t = TestStruct()

    print(t)

    t.c.store(4)

    let g = dispatch_group_create()
    dispatch_group_async(g, dispatch_get_global_queue(qos_class_self(), 0)) {
      print(t)
      let v = t.a.swap(5)
      usleep(1000)
      t.b.store(v, order: .sequential)
    }

    usleep(500)
    print(t)
    dispatch_group_wait(g, DISPATCH_TIME_FOREVER)
    print(t)
    
    print("")
    let pt = UnsafeMutablePointer<TestStruct>.alloc(1)
    pt.memory = TestStruct()
    
    print(pt.memory)

    pt.memory.c.store(4)

    dispatch_group_async(g, dispatch_get_global_queue(qos_class_self(), 0)) {
      print(pt.memory)
      let v = pt.memory.a.swap(5)
      usleep(1000)
      pt.memory.b.store(v, order: .sequential)
    }
    
    usleep(500)
    print(pt.memory)
    dispatch_group_wait(g, DISPATCH_TIME_FOREVER)
    print(pt.memory)

    pt.dealloc(1)
  }
}
