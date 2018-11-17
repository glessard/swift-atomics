//
//  ReferenceTests.swift
//  AtomicsTests
//
//  Created by Guillaume Lessard on 10/9/18.
//  Copyright © 2018 Guillaume Lessard. All rights reserved.
//

import XCTest
import Dispatch

import Atomics

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

private class Thing
{
  let id: UInt
  init(_ x: UInt = UInt.randomPositive()) { id = x }
  deinit { print("Released     \(id)") }
}

public class ReferenceTests: XCTestCase
{
    
    public func testRetainCount() {
        let thing1 = Thing(UInt.randomPositive())
        let thing2 = Thing(UInt.randomPositive())
        let originalRetainCount = CFGetRetainCount(thing1)
        
        var a = AtomicReference(thing1)
        
        _ = a.storeIfNil(thing2)
        var currentRetainCount = CFGetRetainCount(thing1)
        XCTAssertEqual(currentRetainCount, originalRetainCount + 1)
        currentRetainCount = CFGetRetainCount(thing2)
        XCTAssertEqual(currentRetainCount, originalRetainCount)
        
        _ = a.CAS(current: thing1, future: thing2)
        currentRetainCount = CFGetRetainCount(thing1)
        XCTAssertEqual(currentRetainCount, originalRetainCount)
        currentRetainCount = CFGetRetainCount(thing2)
        XCTAssertEqual(currentRetainCount, originalRetainCount + 1)
        
        _ = a.swap(thing1)
        currentRetainCount = CFGetRetainCount(thing1)
        XCTAssertEqual(currentRetainCount, originalRetainCount + 1)
        currentRetainCount = CFGetRetainCount(thing2)
        XCTAssertEqual(currentRetainCount, originalRetainCount)
        
        _ = a.load()
        currentRetainCount = CFGetRetainCount(thing1)
        XCTAssertEqual(currentRetainCount, originalRetainCount + 1)
        currentRetainCount = CFGetRetainCount(thing2)
        XCTAssertEqual(currentRetainCount, originalRetainCount)
    
        _ = a.swap(nil)
        currentRetainCount = CFGetRetainCount(thing1)
        XCTAssertEqual(currentRetainCount, originalRetainCount)
        
        _ = a.storeIfNil(thing1)
        currentRetainCount = CFGetRetainCount(thing1)
        XCTAssertEqual(currentRetainCount, originalRetainCount + 1)
    }
    
  public func testUnmanaged()
  {
    var i = UInt.randomPositive()
    var a = AtomicReference(Thing(i))
    do {
      let r1 = a.swap(.none)
      print("Will release \(i)")
      XCTAssert(r1 != nil)
      XCTAssert(a.load() == nil)
    }

    i = UInt.randomPositive()
    XCTAssert(a.swap(Thing(i)) == nil)
    print("Releasing    \(i)")
    XCTAssert(a.swap(nil) != nil)

    i = UInt.randomPositive()
    XCTAssert(a.storeIfNil(Thing(i)) == true)
    let j = UInt.randomPositive()
    print("Will drop    \(j)")
    // a compiler warning is expected for the next line
    XCTAssert(a.swapIfNil(Thing(j)) == false)

    do {
      let v = a.load()
      XCTAssert(v?.id == i)
    }

    print("Will release \(i)")
    XCTAssert(a.take() != nil)
    XCTAssert(a.take() == nil)
  }
}

private let iterations = 200_000//_000

public class ReferenceRaceTests: XCTestCase
{
#if false
  public func testRaceCrash()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var r: Optional = ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 })
      let closure = {
        while true
        {
          if r != nil
          {
            r = nil
          }
          else
          {
            break
          }
        }
      }

      q.async(execute: closure)
      q.async(execute: closure)
    }

    q.sync(flags: .barrier) {}
  }
#endif

  public func testRaceAtomicReference()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      let b = ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 })
      var r = AtomicReference(b)
      let closure = {
        while true
        {
          if let buffer = r.take()
          {
            XCTAssert(buffer.header == 1)
          }
          else
          {
            break
          }
        }
      }

      q.async(execute: closure)
      q.async(execute: closure)
    }

    q.sync(flags: .barrier) {}
  }
}
