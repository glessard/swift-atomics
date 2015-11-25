//
//  AtomicsTests.swift
//  AtomicsTests
//
//  Created by Guillaume Lessard on 2015-07-06.
//  Copyright © 2015 Guillaume Lessard. All rights reserved.
//

import XCTest

import Darwin
import Dispatch

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
    var randInt = Int(nzRandom())
    let readInt = Read(&randInt)
    XCTAssert(randInt == readInt)

    var randUInt = UInt(nzRandom())
    let readUInt = Read(&randUInt)
    XCTAssert(randUInt == readUInt)

    var randInt32 = Int32(nzRandom())
    let readInt32 = Read(&randInt32)
    XCTAssert(randInt32 == readInt32)

    var randUInt32 = UInt32(nzRandom())
    let readUInt32 = Read(&randUInt32)
    XCTAssert(randUInt32 == readUInt32)

    var randInt64 = Int64(nzRandom())
    let readInt64 = Read(&randInt64)
    XCTAssert(randInt64 == readInt64)

    var randUInt64 = UInt64(nzRandom())
    let readUInt64 = Read(&randUInt64)
    XCTAssert(randUInt64 == readUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let readPtr = Read(&randPtr)
    XCTAssert(randPtr == readPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let readMutPtr = Read(&randMutPtr)
    XCTAssert(randMutPtr == readMutPtr)

    var randOPtr = COpaquePointer(bitPattern: nzRandom())
    let readOPtr = Read(&randOPtr)
    XCTAssert(randOPtr == readOPtr)
  }

    
  func testSyncRead()
  {
    var randInt = Int(nzRandom())
    let readInt = SyncRead(&randInt)
    XCTAssert(randInt == readInt)

    var randUInt = UInt(nzRandom())
    let readUInt = SyncRead(&randUInt)
    XCTAssert(randUInt == readUInt)

    var randInt32 = Int32(nzRandom())
    let readInt32 = SyncRead(&randInt32)
    XCTAssert(randInt32 == readInt32)

    var randUInt32 = UInt32(nzRandom())
    let readUInt32 = SyncRead(&randUInt32)
    XCTAssert(randUInt32 == readUInt32)

    var randInt64 = Int64(nzRandom())
    let readInt64 = SyncRead(&randInt64)
    XCTAssert(randInt64 == readInt64)

    var randUInt64 = UInt64(nzRandom())
    let readUInt64 = SyncRead(&randUInt64)
    XCTAssert(randUInt64 == readUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let readPtr = SyncRead(&randPtr)
    XCTAssert(randPtr == readPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let readMutPtr = SyncRead(&randMutPtr)
    XCTAssert(randMutPtr == readMutPtr)

    var randOPtr = COpaquePointer(bitPattern: nzRandom())
    let readOPtr = SyncRead(&randOPtr)
    XCTAssert(randOPtr == readOPtr)
  }
  
  
  func testStore()
  {
    let randInt = Int(nzRandom())
    var storInt = Int(nzRandom())
    Store(randInt, &storInt)
    XCTAssert(randInt == storInt)

    let randUInt = UInt(nzRandom())
    var storUInt = UInt(nzRandom())
    Store(randUInt, &storUInt)
    XCTAssert(randUInt == storUInt)

    let randInt32 = Int32(nzRandom())
    var storInt32 = Int32(nzRandom())
    Store(randInt32, &storInt32)
    XCTAssert(randInt32 == storInt32)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = UInt32(nzRandom())
    Store(randUInt32, &storUInt32)
    XCTAssert(randUInt32 == storUInt32)

    let randInt64 = Int64(nzRandom())
    var storInt64 = Int64(nzRandom())
    Store(randInt64, &storInt64)
    XCTAssert(randInt64 == storInt64)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = UInt64(nzRandom())
    Store(randUInt64, &storUInt64)
    XCTAssert(randUInt64 == storUInt64)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    Store(randPtr, &storPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    Store(randMutPtr, &storMutPtr)
    XCTAssert(randMutPtr == storMutPtr)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = COpaquePointer(bitPattern: nzRandom())
    Store(randOPtr, &storOPtr)
    XCTAssert(randOPtr == storOPtr)
  }
  
  
  func testSyncStore()
  {
    let randInt = Int(nzRandom())
    var storInt = Int(nzRandom())
    SyncStore(randInt, &storInt)
    XCTAssert(randInt == storInt)

    let randUInt = UInt(nzRandom())
    var storUInt = UInt(nzRandom())
    SyncStore(randUInt, &storUInt)
    XCTAssert(randUInt == storUInt)

    let randInt32 = Int32(nzRandom())
    var storInt32 = Int32(nzRandom())
    SyncStore(randInt32, &storInt32)
    XCTAssert(randInt32 == storInt32)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = UInt32(nzRandom())
    SyncStore(randUInt32, &storUInt32)
    XCTAssert(randUInt32 == storUInt32)

    let randInt64 = Int64(nzRandom())
    var storInt64 = Int64(nzRandom())
    SyncStore(randInt64, &storInt64)
    XCTAssert(randInt64 == storInt64)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = UInt64(nzRandom())
    SyncStore(randUInt64, &storUInt64)
    XCTAssert(randUInt64 == storUInt64)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    SyncStore(randPtr, &storPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    SyncStore(randMutPtr, &storMutPtr)
    XCTAssert(randMutPtr == storMutPtr)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = COpaquePointer(bitPattern: nzRandom())
    SyncStore(randOPtr, &storOPtr)
    XCTAssert(randOPtr == storOPtr)
  }


  func testSwap()
  {
    let randInt = Int(nzRandom())
    var storInt = Int(nzRandom())
    let readInt = Swap(randInt, &storInt)
    XCTAssert(readInt != randInt)
    XCTAssert(randInt == storInt)

    let randUInt = UInt(nzRandom())
    var storUInt = UInt(nzRandom())
    let readUInt = Swap(randUInt, &storUInt)
    XCTAssert(readUInt != randUInt)
    XCTAssert(randUInt == storUInt)

    let randInt32 = Int32(nzRandom())
    var storInt32 = Int32(nzRandom())
    let readInt32 = Swap(randInt32, &storInt32)
    XCTAssert(readInt32 != randInt32)
    XCTAssert(randInt32 == storInt32)

    let randUInt32 = UInt32(nzRandom())
    var storUInt32 = UInt32(nzRandom())
    let readUInt32 = Swap(randUInt32, &storUInt32)
    XCTAssert(readUInt32 != randUInt32)
    XCTAssert(randUInt32 == storUInt32)

    let randInt64 = Int64(nzRandom())
    var storInt64 = Int64(nzRandom())
    let readInt64 = Swap(randInt64, &storInt64)
    XCTAssert(readInt64 != randInt64)
    XCTAssert(randInt64 == storInt64)

    let randUInt64 = UInt64(nzRandom())
    var storUInt64 = UInt64(nzRandom())
    let readUInt64 = Swap(randUInt64, &storUInt64)
    XCTAssert(readUInt64 != randUInt64)
    XCTAssert(randUInt64 == storUInt64)

    let randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    var storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let readPtr = Swap(randPtr, &storPtr)
    XCTAssert(readPtr != randPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let readMutPtr = Swap(randMutPtr, &storMutPtr)
    XCTAssert(readMutPtr != randMutPtr)
    XCTAssert(randMutPtr == storMutPtr)

    let randOPtr = COpaquePointer(bitPattern: nzRandom())
    var storOPtr = COpaquePointer(bitPattern: nzRandom())
    let readOPtr = Swap(randOPtr, &storOPtr)
    XCTAssert(readOPtr != randOPtr)
    XCTAssert(randOPtr == storOPtr)
  }

  func testAdd()
  {
    let fInt = Int(nzRandom())
    let sInt = Int(nzRandom())
    var rInt = sInt
    XCTAssert(Add(fInt, to: &rInt) == sInt)
    XCTAssert(rInt == fInt+sInt)

    let fUInt = UInt(nzRandom())
    let sUInt = UInt(nzRandom())
    var rUInt = sUInt
    XCTAssert(Add(fUInt, to: &rUInt) == sUInt)
    XCTAssert(rUInt == fUInt+sUInt)

    let fInt32 = Int32(nzRandom())
    let sInt32 = Int32(nzRandom())
    var rInt32 = sInt32
    XCTAssert(Add(fInt32, to: &rInt32) == sInt32)
    XCTAssert(rInt32 == fInt32+sInt32)

    let fUInt32 = UInt32(nzRandom())
    let sUInt32 = UInt32(nzRandom())
    var rUInt32 = sUInt32
    XCTAssert(Add(fUInt32, to: &rUInt32) == sUInt32)
    XCTAssert(rUInt32 == fUInt32+sUInt32)

    let fInt64 = Int64(nzRandom())
    let sInt64 = Int64(nzRandom())
    var rInt64 = sInt64
    XCTAssert(Add(fInt64, to: &rInt64) == sInt64)
    XCTAssert(rInt64 == fInt64+sInt64)

    let fUInt64 = UInt64(nzRandom())
    let sUInt64 = UInt64(nzRandom())
    var rUInt64 = sUInt64
    XCTAssert(Add(fUInt64, to: &rUInt64) == sUInt64)
    XCTAssert(rUInt64 == fUInt64+sUInt64)
  }

  func testSub()
  {
    let fInt = Int(nzRandom())
    var rInt = fInt
    XCTAssert(Sub(1, from: &rInt) == fInt)
    XCTAssert(rInt == fInt-1)

    let fUInt = UInt(nzRandom())
    var rUInt = fUInt
    XCTAssert(Sub(1, from: &rUInt) == fUInt)
    XCTAssert(rUInt == fUInt-1)

    let fInt32 = Int32(nzRandom())
    var rInt32 = fInt32
    XCTAssert(Sub(1, from: &rInt32) == fInt32)
    XCTAssert(rInt32 == fInt32-1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = fUInt32
    XCTAssert(Sub(1, from: &rUInt32) == fUInt32)
    XCTAssert(rUInt32 == fUInt32-1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = fInt64
    XCTAssert(Sub(1, from: &rInt64) == fInt64)
    XCTAssert(rInt64 == fInt64-1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = fUInt64
    XCTAssert(Sub(1, from: &rUInt64) == fUInt64)
    XCTAssert(rUInt64 == fUInt64-1)
  }

  func testIncrement()
  {
    let fInt = Int(nzRandom())
    var rInt = fInt
    XCTAssert(Increment(&rInt) == fInt)
    XCTAssert(rInt == fInt+1)

    let fUInt = UInt(nzRandom())
    var rUInt = fUInt
    XCTAssert(Increment(&rUInt) == fUInt)
    XCTAssert(rUInt == fUInt+1)

    let fInt32 = Int32(nzRandom())
    var rInt32 = fInt32
    XCTAssert(Increment(&rInt32) == fInt32)
    XCTAssert(rInt32 == fInt32+1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = fUInt32
    XCTAssert(Increment(&rUInt32) == fUInt32)
    XCTAssert(rUInt32 == fUInt32+1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = fInt64
    XCTAssert(Increment(&rInt64) == fInt64)
    XCTAssert(rInt64 == fInt64+1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = fUInt64
    XCTAssert(Increment(&rUInt64) == fUInt64)
    XCTAssert(rUInt64 == fUInt64+1)
  }

  func testDecrement()
  {
    let fInt = Int(nzRandom())
    var rInt = fInt
    XCTAssert(Decrement(&rInt) == fInt)
    XCTAssert(rInt == fInt-1)

    let fUInt = UInt(nzRandom())
    var rUInt = fUInt
    XCTAssert(Decrement(&rUInt) == fUInt)
    XCTAssert(rUInt == fUInt-1)

    let fInt32 = Int32(nzRandom())
    var rInt32 = fInt32
    XCTAssert(Decrement(&rInt32) == fInt32)
    XCTAssert(rInt32 == fInt32-1)

    let fUInt32 = UInt32(nzRandom())
    var rUInt32 = fUInt32
    XCTAssert(Decrement(&rUInt32) == fUInt32)
    XCTAssert(rUInt32 == fUInt32-1)

    let fInt64 = Int64(nzRandom())
    var rInt64 = fInt64
    XCTAssert(Decrement(&rInt64) == fInt64)
    XCTAssert(rInt64 == fInt64-1)

    let fUInt64 = UInt64(nzRandom())
    var rUInt64 = fUInt64
    XCTAssert(Decrement(&rUInt64) == fUInt64)
    XCTAssert(rUInt64 == fUInt64-1)
  }
  
  func testCAS()
  {
    var randInt = Int(nzRandom())
    let storInt = Int(nzRandom())
    XCTAssertFalse(CAS(0, randInt, &randInt))
    XCTAssert(CAS(randInt, storInt, &randInt))
    XCTAssert(randInt == storInt)

    var randUInt = UInt(nzRandom())
    let storUInt = UInt(nzRandom())
    XCTAssertFalse(CAS(0, randUInt, &randUInt))
    XCTAssert(CAS(randUInt, storUInt, &randUInt))
    XCTAssert(randUInt == storUInt)

    var randInt32 = Int32(nzRandom())
    let storInt32 = Int32(nzRandom())
    XCTAssertFalse(CAS(0, randInt32, &randInt32))
    XCTAssert(CAS(randInt32, storInt32, &randInt32))
    XCTAssert(randInt32 == storInt32)

    var randUInt32 = UInt32(nzRandom())
    let storUInt32 = UInt32(nzRandom())
    XCTAssertFalse(CAS(0, randUInt32, &randUInt32))
    XCTAssert(CAS(randUInt32, storUInt32, &randUInt32))
    XCTAssert(randUInt32 == storUInt32)

    var randInt64 = Int64(nzRandom())
    let storInt64 = Int64(nzRandom())
    XCTAssertFalse(CAS(0, randInt64, &randInt64))
    XCTAssert(CAS(randInt64, storInt64, &randInt64))
    XCTAssert(randInt64 == storInt64)

    var randUInt64 = UInt64(nzRandom())
    let storUInt64 = UInt64(nzRandom())
    XCTAssertFalse(CAS(0, randUInt64, &randUInt64))
    XCTAssert(CAS(randUInt64, storUInt64, &randUInt64))
    XCTAssert(randUInt64 == storUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    let storPtr = UnsafePointer<CGPoint>(bitPattern: nzRandom())
    XCTAssertFalse(CAS(nil, randPtr, &randPtr))
    XCTAssert(CAS(randPtr, storPtr, &randPtr))
    XCTAssert(randPtr == storPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    let storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: nzRandom())
    XCTAssertFalse(CAS(nil, randMutPtr, &randMutPtr))
    XCTAssert(CAS(randMutPtr, storMutPtr, &randMutPtr))
    XCTAssert(randMutPtr == storMutPtr)

    var randOPtr = COpaquePointer(bitPattern: nzRandom())
    let storOPtr = COpaquePointer(bitPattern: nzRandom())
    XCTAssertFalse(CAS(nil, randOPtr, &randOPtr))
    XCTAssert(CAS(randOPtr, storOPtr, &randOPtr))
    XCTAssert(randOPtr == storOPtr)
  }

  private struct TestStruct: CustomStringConvertible
  {
    var a = 0
    var b = 1
    var c = 2
    var d = 3

    var description: String { return "\(a) \(b) \(c) \(d)" }
  }

  func testExample()
  {
    var value = 0

    print(Swap(1, &value))
    print(value)
    Store(2, &value)
    print(value)

    var p = UnsafeMutablePointer<Int>.alloc(1)

    print(p)

    var q = Read(&p)
    let r = Swap(UnsafeMutablePointer<Int>.alloc(1), &q)
    Store(q, &p)

    print(q)
    print(r)
    print(p)
    print("")

    var pp = UnsafePointer<Int>(UnsafeMutablePointer<Int>.alloc(1))

    print(pp)

    var qq = Read(&pp)
    let rr = Swap(UnsafePointer(UnsafeMutablePointer<Int>.alloc(1)), &qq)
    Store(qq, &pp)

    print(qq)
    print(rr)
    print(pp)
    print("")

    var i = Int32(nzRandom())

    print(i)

    var j = Read(&i)
    let k = Swap(Int32(nzRandom()), &j)
    Store(j, &i)

    print(j)
    print(k)
    print(i)
    print("")

    var ii = Int64(nzRandom())

    print(ii)

    var jj = Read(&ii)
    let kk = Swap(numericCast(nzRandom()), &jj)
    Store(jj, &ii)

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
      value = random()
    }
    dt = mach_absolute_time() - start
    print(dt/numericCast(iterations))

    start = mach_absolute_time()
    for _ in 1...iterations
    {
      Store(random(), &value)
    }
    dt = mach_absolute_time() - start
    print(dt/numericCast(iterations))

    start = mach_absolute_time()
    for _ in 1...iterations
    {
      SyncStore(random(), &value)
    }
    dt = mach_absolute_time() - start
    print(dt/numericCast(iterations))

    var t = TestStruct()

    print(t)

    Store(4, &t.c)

    let g = dispatch_group_create()
    dispatch_group_async(g, dispatch_get_global_queue(qos_class_self(), 0)) {
      print(t)
      let v = Swap(5, &t.a)
      usleep(1000)
      SyncStore(v, &t.b)
    }

    usleep(500)
    print(t)
    dispatch_group_wait(g, DISPATCH_TIME_FOREVER)
    print(t)
    
    print("")
    let pt = UnsafeMutablePointer<TestStruct>.alloc(1)
    pt.memory = TestStruct()
    
    print(pt.memory)
    
    Store(4, &pt.memory.c)
    
    dispatch_group_async(g, dispatch_get_global_queue(qos_class_self(), 0)) {
      print(pt.memory)
      let v = Swap(5, &pt.memory.a)
      usleep(1000)
      SyncStore(v, &pt.memory.b)
    }
    
    usleep(500)
    print(pt.memory)
    dispatch_group_wait(g, DISPATCH_TIME_FOREVER)
    print(pt.memory)

    pt.dealloc(1)
  }
}
