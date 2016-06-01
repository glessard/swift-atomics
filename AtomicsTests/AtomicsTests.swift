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

    var randInt32 = Int32(nzRandom())
    let readInt32 = randInt32.atomicRead(synchronized: false)
    XCTAssert(randInt32 == readInt32)

    var randUInt32 = UInt32(nzRandom())
    let readUInt32 = randUInt32.atomicRead(synchronized: false)
    XCTAssert(randUInt32 == readUInt32)

    var randInt64 = Int64(nzRandom())
    let readInt64 = randInt64.atomicRead(synchronized: false)
    XCTAssert(randInt64 == readInt64)

    var randUInt64 = UInt64(nzRandom())
    let readUInt64 = randUInt64.atomicRead(synchronized: false)
    XCTAssert(randUInt64 == readUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let readPtr = randPtr.atomicRead(synchronized: false)
    XCTAssert(randPtr == readPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let readMutPtr = randMutPtr.atomicRead(synchronized: false)
    XCTAssert(randMutPtr == readMutPtr)

    var randOPtr = COpaquePointer(bitPattern: nzRandom())
    let readOPtr = randOPtr.atomicRead(synchronized: false)
    XCTAssert(randOPtr == readOPtr)
  }

    
  func testSyncRead()
  {
    var randInt = AtomicInt(Int(nzRandom()))
    let readInt = randInt.load(.sequential)
    XCTAssert(randInt.value == readInt)

    var randUInt = AtomicUInt(UInt(nzRandom()))
    let readUInt = randUInt.load(.sequential)
    XCTAssert(randUInt.value == readUInt)

    var randInt32 = Int32(nzRandom())
    let readInt32 = randInt32.atomicRead(synchronized: true)
    XCTAssert(randInt32 == readInt32)

    var randUInt32 = UInt32(nzRandom())
    let readUInt32 = randUInt32.atomicRead(synchronized: true)
    XCTAssert(randUInt32 == readUInt32)

    var randInt64 = Int64(nzRandom())
    let readInt64 = randInt64.atomicRead(synchronized: true)
    XCTAssert(randInt64 == readInt64)

    var randUInt64 = UInt64(nzRandom())
    let readUInt64 = randUInt64.atomicRead(synchronized: true)
    XCTAssert(randUInt64 == readUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let readPtr = randPtr.atomicRead(synchronized: true)
    XCTAssert(randPtr == readPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let readMutPtr = randMutPtr.atomicRead(synchronized: true)
    XCTAssert(randMutPtr == readMutPtr)

    var randOPtr = COpaquePointer(bitPattern: nzRandom())
    let readOPtr = randOPtr.atomicRead(synchronized: true)
    XCTAssert(randOPtr == readOPtr)
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
    var storInt32 = Int32(nzRandom())
    storInt32.atomicStore(randInt32, synchronized: false)
    XCTAssert(randInt32 == storInt32)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = UInt32(nzRandom())
    storUInt32.atomicStore(randUInt32, synchronized: false)
    XCTAssert(randUInt32 == storUInt32)

    let randInt64 = Int64(nzRandom())
    var storInt64 = Int64(nzRandom())
    storInt64.atomicStore(randInt64, synchronized: false)
    XCTAssert(randInt64 == storInt64)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = UInt64(nzRandom())
    storUInt64.atomicStore(randUInt64, synchronized: false)
    XCTAssert(randUInt64 == storUInt64)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    storPtr.atomicStore(randPtr, synchronized: false)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    storMutPtr.atomicStore(randMutPtr, synchronized: false)
    XCTAssert(randMutPtr == storMutPtr)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = COpaquePointer(bitPattern: nzRandom())
    storOPtr.atomicStore(randOPtr, synchronized: false)
    XCTAssert(randOPtr == storOPtr)
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
    var storInt32 = Int32(nzRandom())
    storInt32.atomicStore(randInt32, synchronized: true)
    XCTAssert(randInt32 == storInt32)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = UInt32(nzRandom())
    storUInt32.atomicStore(randUInt32, synchronized: true)
    XCTAssert(randUInt32 == storUInt32)

    let randInt64 = Int64(nzRandom())
    var storInt64 = Int64(nzRandom())
    storInt64.atomicStore(randInt64, synchronized: true)
    XCTAssert(randInt64 == storInt64)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = UInt64(nzRandom())
    storUInt64.atomicStore(randUInt64, synchronized: true)
    XCTAssert(randUInt64 == storUInt64)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    storPtr.atomicStore(randPtr, synchronized: true)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    storMutPtr.atomicStore(randMutPtr, synchronized: true)
    XCTAssert(randMutPtr == storMutPtr)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = COpaquePointer(bitPattern: nzRandom())
    storOPtr.atomicStore(randOPtr, synchronized: true)
    XCTAssert(randOPtr == storOPtr)
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
    var storInt32 = Int32(nzRandom())
    let readInt32 = storInt32.atomicSwap(randInt32)
    XCTAssert(readInt32 != randInt32)
    XCTAssert(randInt32 == storInt32)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = UInt32(nzRandom())
    let readUInt32 = storUInt32.atomicSwap(randUInt32)
    XCTAssert(readUInt32 != randUInt32)
    XCTAssert(randUInt32 == storUInt32)

    let randInt64 = Int64(nzRandom())
    var storInt64 = Int64(nzRandom())
    let readInt64 = storInt64.atomicSwap(randInt64)
    XCTAssert(readInt64 != randInt64)
    XCTAssert(randInt64 == storInt64)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = UInt64(nzRandom())
    let readUInt64 = storUInt64.atomicSwap(randUInt64)
    XCTAssert(readUInt64 != randUInt64)
    XCTAssert(randUInt64 == storUInt64)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let readPtr = storPtr.atomicSwap(randPtr)
    XCTAssert(readPtr != randPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let readMutPtr = storMutPtr.atomicSwap(randMutPtr)
    XCTAssert(readMutPtr != randMutPtr)
    XCTAssert(randMutPtr == storMutPtr)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = COpaquePointer(bitPattern: nzRandom())
    let readOPtr = storOPtr.atomicSwap(randOPtr)
    XCTAssert(readOPtr != randOPtr)
    XCTAssert(randOPtr == storOPtr)
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
    var rInt32 = sInt32
    XCTAssert(rInt32.atomicAdd(fInt32) == sInt32)
    XCTAssert(rInt32 == fInt32+sInt32)

    let fUInt32 = UInt32(nzRandom())
    let sUInt32 = UInt32(nzRandom())
    var rUInt32 = sUInt32
    XCTAssert(rUInt32.atomicAdd(fUInt32) == sUInt32)
    XCTAssert(rUInt32 == fUInt32+sUInt32)

    let fInt64 = Int64(nzRandom())
    let sInt64 = Int64(nzRandom())
    var rInt64 = sInt64
    XCTAssert(rInt64.atomicAdd(fInt64) == sInt64)
    XCTAssert(rInt64 == fInt64+sInt64)

    let fUInt64 = UInt64(nzRandom())
    let sUInt64 = UInt64(nzRandom())
    var rUInt64 = sUInt64
    XCTAssert(rUInt64.atomicAdd(fUInt64) == sUInt64)
    XCTAssert(rUInt64 == fUInt64+sUInt64)
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
    var rInt32 = fInt32
    XCTAssert(rInt32.atomicSub(1) == fInt32)
    XCTAssert(rInt32 == fInt32-1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = fUInt32
    XCTAssert(rUInt32.atomicSub(1) == fUInt32)
    XCTAssert(rUInt32 == fUInt32-1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = fInt64
    XCTAssert(rInt64.atomicSub(1) == fInt64)
    XCTAssert(rInt64 == fInt64-1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = fUInt64
    XCTAssert(rUInt64.atomicSub(1) == fUInt64)
    XCTAssert(rUInt64 == fUInt64-1)
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
    var rInt32 = fInt32
    XCTAssert(rInt32.increment() == fInt32)
    XCTAssert(rInt32 == fInt32+1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = fUInt32
    XCTAssert(rUInt32.increment() == fUInt32)
    XCTAssert(rUInt32 == fUInt32+1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = fInt64
    XCTAssert(rInt64.increment() == fInt64)
    XCTAssert(rInt64 == fInt64+1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = fUInt64
    XCTAssert(rUInt64.increment() == fUInt64)
    XCTAssert(rUInt64 == fUInt64+1)
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
    var rInt32 = fInt32
    XCTAssert(rInt32.decrement() == fInt32)
    XCTAssert(rInt32 == fInt32-1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = fUInt32
    XCTAssert(rUInt32.decrement() == fUInt32)
    XCTAssert(rUInt32 == fUInt32-1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = fInt64
    XCTAssert(rInt64.decrement() == fInt64)
    XCTAssert(rInt64 == fInt64-1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = fUInt64
    XCTAssert(rUInt64.decrement() == fUInt64)
    XCTAssert(rUInt64 == fUInt64-1)
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

    var randInt32 = Int32(nzRandom())
    let storInt32 = Int32(nzRandom())
    XCTAssertFalse(randInt32.CAS(current: 0, future: randInt32))
    XCTAssert(randInt32.CAS(current: randInt32, future: storInt32))
    XCTAssert(randInt32 == storInt32)

    var randUInt32 = UInt32(nzRandom())
    let storUInt32 = UInt32(nzRandom())
    XCTAssertFalse(randUInt32.CAS(current: 0, future: randUInt32))
    XCTAssert(randUInt32.CAS(current: randUInt32, future: storUInt32))
    XCTAssert(randUInt32 == storUInt32)

    var randInt64 = Int64(nzRandom())
    let storInt64 = Int64(nzRandom())
    XCTAssertFalse(randInt64.CAS(current: 0, future: randInt64))
    XCTAssert(randInt64.CAS(current: randInt64, future: storInt64))
    XCTAssert(randInt64 == storInt64)

    var randUInt64 = UInt64(nzRandom())
    let storUInt64 = UInt64(nzRandom())
    XCTAssertFalse(randUInt64.CAS(current: 0, future: randUInt64))
    XCTAssert(randUInt64.CAS(current: randUInt64, future: storUInt64))
    XCTAssert(randUInt64 == storUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    XCTAssertFalse(randPtr.CAS(current: nil, future: randPtr))
    XCTAssert(randPtr.CAS(current: randPtr, future: storPtr))
    XCTAssert(randPtr == storPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    XCTAssertFalse(randMutPtr.CAS(current: nil, future: randMutPtr))
    XCTAssert(randMutPtr.CAS(current: randMutPtr, future: storMutPtr))
    XCTAssert(randMutPtr == storMutPtr)

    var randOPtr = COpaquePointer(bitPattern: nzRandom())
    let storOPtr = COpaquePointer(bitPattern: nzRandom())
    XCTAssertFalse(randOPtr.CAS(current: nil, future: randOPtr))
    XCTAssert(randOPtr.CAS(current: randOPtr, future: storOPtr))
    XCTAssert(randOPtr == storOPtr)
  }

  func testPerformanceStore()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.value = 0
      for i in 0..<1_000_000 { m.store(i, order: .relaxed) }
    }
  }
  
  func testPerformanceSynchronizedStore()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.value = 0
      for i in 0..<1_000_000 { m.store(i, order: .sequential) }
    }
  }

  func testPerformanceRead()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.value = 0
      for i in 0..<1_000_000
      {
        m.value = i
        guard m.load(.relaxed) == i else { XCTFail(); break }
      }
    }
  }

  func testPerformanceSynchronizedRead()
  {
    var m = AtomicInt(0)
    measureBlock {
      m.value = 0
      for i in 0..<1_000_000
      {
        m.value = i
        guard m.load(.sequential) == i else { XCTFail(); break }
      }
    }
  }

  func testPerformanceSwiftCASSuccess()
  {
    var m = Int32(0)
    measureBlock {
      m = 0
      for i in m..<1_000_000 { m.CAS(current: m, future: i) }
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
    var m = Int32(0)
    measureBlock {
      m = 0
      for i in m..<1_000_000 { m.CAS(current: i, future: 0) }
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

    var p = UnsafeMutablePointer<Int>.alloc(1)

    print(p)

    var q = p.atomicRead()
    let r = q.atomicSwap(UnsafeMutablePointer<Int>.alloc(1))
    p.atomicStore(q)

    print(q)
    print(r)
    print(p)
    print("")

    var pp = UnsafePointer<Int>(UnsafeMutablePointer<Int>.alloc(1))

    print(pp)

    var qq = pp.atomicRead()
    let rr = qq.atomicSwap(UnsafePointer(UnsafeMutablePointer<Int>.alloc(1)))
    pp.atomicStore(qq)

    print(qq)
    print(rr)
    print(pp)
    print("")

    var i = Int32(nzRandom())

    print(i)

    var j = i.atomicRead()
    let k = j.atomicSwap(Int32(nzRandom()))
    i.atomicStore(j)

    print(j)
    print(k)
    print(i)
    print("")

    var ii = Int64(nzRandom())

    print(ii)

    var jj = ii.atomicRead()
    let kk = jj.atomicSwap(numericCast(nzRandom()))
    ii.atomicStore(jj)

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
      value.value = random()
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
