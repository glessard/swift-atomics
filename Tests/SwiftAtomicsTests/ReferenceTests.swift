//
//  ReferenceTests.swift
//  AtomicsTests
//
//  Created by Guillaume Lessard on 10/9/18.
//  Copyright © 2018 Guillaume Lessard. All rights reserved.
//

import XCTest
import Dispatch

import SwiftAtomics

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
      XCTAssertNotNil(r1)
      XCTAssertNil(a.swap(nil))
    }

    i = UInt.randomPositive()
    XCTAssertNil(a.swap(Witness(i)))
    print("Releasing    \(i)")
    XCTAssertNotNil(a.swap(nil))

    i = UInt.randomPositive()
    XCTAssertEqual(a.storeIfNil(Witness(i)), true)
    var j = UInt.randomPositive()
    print("Will drop    \(j)")
    // a compiler warning is expected for the next line
#if swift(>=5.0)
    XCTAssertEqual(a.storeIfNil(Witness(j)), false)
#else
    XCTAssertEqual(a.swapIfNil(Witness(j), order: .release), false)
#endif

    weak var witnessi: Witness? = {
      let w = a.swap(nil)
      XCTAssertNotNil(w)
      XCTAssertTrue(a.storeIfNil(w!))
      return w
    }()
    XCTAssertNotNil(witnessi)
    XCTAssertEqual(witnessi?.id, i)

    j = UInt.randomPositive()
    var witnessj = Optional(Witness(j))
    XCTAssertFalse(a.CAS(current: nil, future: witnessi))
    XCTAssertFalse(a.CAS(current: witnessj, future: witnessi))

    print("Will release \(i)")
    XCTAssertTrue(a.CAS(current: witnessi, future: witnessj))
    witnessj = nil

    print("Will release \(j)")
    XCTAssertNotNil(a.take())
    XCTAssertNil(a.take())
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
      var r = AtomicReference(ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 }))

      let closure = {
        while true
        {
          if let buffer = r.take()
          {
            XCTAssertEqual(buffer.header, 1)
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
