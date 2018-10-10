//
//  CAtomicsReferenceTests.swift
//  CAtomicsTests
//
//  Created by Guillaume Lessard on 10/10/18.
//  Copyright © 2018 Guillaume Lessard. All rights reserved.
//

import XCTest
import Dispatch

import CAtomics

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

private class Thing
{
  let id: UInt
  init(_ x: UInt = UInt.randomPositive()) { id = x }
  deinit { print("Released     \(id)") }
}

public class UnmanagedTests: XCTestCase
{
  public func testUnmanaged()
  {
    var i = UInt.randomPositive()
    var u = Unmanaged.passRetained(Thing(i))
    var a = RawUnmanaged()
    a.initialize(u.toOpaque())
    do {
      let p = a.spinSwap(nil, .relaxed)
      print("Will release \(i)")
      XCTAssert(p != nil)
      let r = p.map { Unmanaged<Thing>.fromOpaque($0).takeRetainedValue() }
      XCTAssert(r != nil)
    }

    i = UInt.randomPositive()
    u = Unmanaged.passRetained(Thing(i))
    XCTAssert(a.spinSwap(u.toOpaque(), .release) == nil)
    print("Releasing    \(i)")
    let p = a.spinSwap(nil, .acquire)
    XCTAssert(p != nil)
    _ = p.map { Unmanaged<Thing>.fromOpaque($0).takeRetainedValue() }

    i = UInt.randomPositive()
    u = Unmanaged.passRetained(Thing(i))
    XCTAssert(a.safeStore(u.toOpaque(), .release) == true)
    XCTAssert(a.safeStore(u.toOpaque(), .relaxed) == false)

    let v = a.spinLoad(.lock, .acquire)
    XCTAssert(v != nil)
    XCTAssert(v == UnsafeRawPointer(u.toOpaque()))
    XCTAssert(a.rawLoad(.relaxed) == UnsafeRawPointer(bitPattern: 0x7))
    a.rawStore(nil, .relaxed)
    print("Releasing    \(i)")
    v.map { Unmanaged<Thing>.fromOpaque($0).release() }
  }
}

private let iterations = 200_000//_000

public class UnmanagedRaceTests: XCTestCase
{
  public func testRaceAtomickishUnmanaged()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var r = RawUnmanaged()
      r.initialize({
        () -> UnsafeMutableRawPointer in
        let b = ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 })
        let u = Unmanaged.passRetained(b)
        return u.toOpaque()
      }())
      let closure = {
        while true
        {
          if let p = r.spinLoad(.null, .relaxed)
          {
            let buffer = Unmanaged<ManagedBuffer<Int, Int>>.fromOpaque(p).takeRetainedValue()
            XCTAssert(buffer.header == 1)
          }
          else
          {
            XCTAssert(r.rawLoad(.relaxed) == nil)
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
