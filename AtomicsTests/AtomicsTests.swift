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

#if os(OSX)
  import Atomics
#elseif os(iOS)
  import Atomics_iOS
#endif

class AtomicsTests: XCTestCase
{
  func nzRandom() -> Int
  {
    // Return a positive Int less than (or equal to) Int32.max.
    return Int(arc4random() & 0x7fff_fffe + 1)
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

    var randUInt64 = Int64(nzRandom())
    let readUInt64 = Read(&randUInt64)
    XCTAssert(randUInt64 == readUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let readPtr = Read(&randPtr)
    XCTAssert(randPtr == readPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let readMutPtr = Read(&randMutPtr)
    XCTAssert(randMutPtr == readMutPtr)
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

    var randUInt64 = Int64(nzRandom())
    let readUInt64 = SyncRead(&randUInt64)
    XCTAssert(randUInt64 == readUInt64)

    var randPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let readPtr = SyncRead(&randPtr)
    XCTAssert(randPtr == readPtr)

    var randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let readMutPtr = SyncRead(&randMutPtr)
    XCTAssert(randMutPtr == readMutPtr)
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

    let randPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    var storPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    Store(randPtr, &storPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    Store(randMutPtr, &storMutPtr)
    XCTAssert(randMutPtr == storMutPtr)
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

    let randPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    var storPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    SyncStore(randPtr, &storPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    SyncStore(randMutPtr, &storMutPtr)
    XCTAssert(randMutPtr == storMutPtr)
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

    let randPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    var storPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let readPtr = Swap(randPtr, &storPtr)
    XCTAssert(readPtr != randPtr)
    XCTAssert(randPtr == storPtr)

    let randMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    var storMutPtr = UnsafeMutablePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let readMutPtr = Swap(randMutPtr, &storMutPtr)
    XCTAssert(readMutPtr != randMutPtr)
    XCTAssert(randMutPtr == storMutPtr)
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

    var randPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let storPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    XCTAssertFalse(CAS(nil, randPtr, &randPtr))
    XCTAssert(CAS(randPtr, storPtr, &randPtr))
    XCTAssert(randPtr == storPtr)

    var randMutPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    let storMutPtr = UnsafePointer<CGPoint>(bitPattern: UInt(nzRandom()))
    XCTAssertFalse(CAS(nil, randMutPtr, &randMutPtr))
    XCTAssert(CAS(randMutPtr, storMutPtr, &randMutPtr))
    XCTAssert(randMutPtr == storMutPtr)
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

    var j = Read32(&i)
    let k = Swap32(Int32(nzRandom()), &j)
    Store32(j, &i)

    print(j)
    print(k)
    print(i)
    print("")

    var ii = Int64(nzRandom())

    print(ii)

    var jj = Read64(&ii)
    let kk = Swap64(numericCast(nzRandom()), &jj)
    Store64(jj, &ii)

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
