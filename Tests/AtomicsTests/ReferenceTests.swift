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
}

private class Witness: Thing
{
  override init(_ x: UInt) { super.init(x) }
  deinit { print("Released     \(id)") }
}

public class ReferenceTests: XCTestCase
{
  public func testUnmanaged()
  {
    var i = UInt.randomPositive()
    var a = AtomicReference(Witness(i))
    do {
      let r1 = a.swap(.none)
      print("Will release \(i)")
      XCTAssert(r1 != nil)
      XCTAssert(a.load() == nil)
    }

    i = UInt.randomPositive()
    XCTAssert(a.swap(Witness(i)) == nil)
    print("Releasing    \(i)")
    XCTAssert(a.swap(nil) != nil)

    i = UInt.randomPositive()
    XCTAssert(a.storeIfNil(Witness(i)) == true)
    var j = UInt.randomPositive()
    print("Will drop    \(j)")
    // a compiler warning is expected for the next line
    XCTAssert(a.swapIfNil(Witness(j)) == false)

    weak var witnessi = a.load()
    XCTAssert(witnessi?.id == i)

    j = UInt.randomPositive()
    var witnessj = Optional(Witness(j))
    XCTAssertFalse(a.CAS(current: nil, future: witnessi))
    XCTAssertFalse(a.CAS(current: witnessj, future: witnessi))

    print("Will release \(i)")
    XCTAssertTrue(a.CAS(current: witnessi, future: witnessj))
    witnessj = nil

    print("Will release \(j)")
    XCTAssert(a.take() != nil)
    XCTAssert(a.take() == nil)
  }
}

public class TaggedReferenceTests: XCTestCase
{
    public func testUnmanaged()
    {
        var i = UInt.randomPositive()
        let x = Int.randomPositive()
        let y = Int.randomPositive()
        var a = AtomicTaggedReference(Witness(i), tag: x)
        do {
            let r1 = a.swap(.none, tag: y)
            print("Will release \(i)")
            XCTAssert(r1.ref != nil && r1.tag == x)
            let r2 = a.load()
            XCTAssert(r2.ref == nil && r2.tag == y)
        }
        
        i = UInt.randomPositive()
        var r = a.swap(Witness(i), tag: 0)
        XCTAssert(r.ref == nil && r.tag == y)
        print("Releasing    \(i)")
        r = a.swap(nil, tag: x)
        XCTAssert(r.ref != nil && r.tag == 0)

        i = UInt.randomPositive()
//        XCTAssert(a.storeIfNil(Witness(i)) == true)
//        var j = UInt.randomPositive()
//        print("Will drop    \(j)")
//        // a compiler warning is expected for the next line
//        XCTAssert(a.swapIfNil(Witness(j)) == false)
//
        a.swap(Witness(i), tag: x)
        weak var witnessi = a.load().ref
        XCTAssert(witnessi?.id == i)

        var j = UInt.randomPositive()
        var witnessj = Optional(Witness(j))
        XCTAssertFalse(a.CAS(current: (nil, x), future: (witnessi, y)))
        XCTAssertFalse(a.CAS(current: (witnessj, x), future: (witnessi, y)))

        print("Will release \(i)")
        XCTAssertTrue(a.CAS(current: (witnessi, x), future: (witnessj, y)))
        witnessj = nil
        
        r = a.load()
        XCTAssert(r.ref?.id == j && r.tag == y)
//
//        print("Will release \(j)")
//        XCTAssert(a.take() != nil)
//        XCTAssert(a.take() == nil)
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

  public func testRaceLoadVersusDeinit()
  {
    let q = DispatchQueue(label: #function, attributes: .concurrent)

    for _ in 1...iterations
    {
      var r = AtomicReference(Thing())

      let closure = {
        (b: Bool) -> () -> Void in
        return {
          () -> Void in
          var c = b
          while true
          {
            let thing = c ? r.load() : r.swap(nil)
            if thing == nil { return }
            c = !c
          }
        }
      }

      q.async(execute: closure(true))
      q.async(execute: closure(false))
    }

    q.sync(flags: .barrier) {}
  }

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
    
    public func testRaceTaggedLoadVersusDeinit()
    {
        let q = DispatchQueue(label: #function, attributes: .concurrent)
        
        for _ in 1...iterations
        {
            var r = AtomicTaggedReference(Thing(), tag: 0)
            
            let closure = {
                (b: Bool) -> () -> Void in
                return {
                    () -> Void in
                    var c = b
                    while true
                    {
                        let thing = c ? r.load() : r.swap(nil, tag: 0)
                        if thing.ref == nil { return }
                        c = !c
                    }
                }
            }
            
            q.async(execute: closure(true))
            q.async(execute: closure(false))
        }
        
        q.sync(flags: .barrier) {}
    }
    
    public func testRaceAtomicTaggedReference()
    {
        let q = DispatchQueue(label: "", attributes: .concurrent)
        
        for _ in 1...iterations
        {
            let b = ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 })
            var r = AtomicTaggedReference(b, tag: 0)
            let closure = {
                while true
                {
                    if let buffer = r.take().ref
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
