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

private enum TestError: Error { case value(UInt) }

private class Thing
{
  let id: UInt
  init(_ x: UInt) { id = x }
}

private class Witness: Thing
{
  override init(_ x: UInt) { super.init(x) }
  deinit { print("Released  \(id)") }
}

public class UnmanagedTests: XCTestCase
{
  public func testUnmanaged()
  {
    var i = UInt.randomPositive()
    var u = Unmanaged.passRetained(Witness(i))
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, u.toOpaque())
    do {
      let p = CAtomicsExchange(&a, nil, .relaxed)
      print("Releasing \(i)")
      XCTAssertNotNil(p)
      let r = p.map(Unmanaged<Witness>.fromOpaque)?.takeRetainedValue()
      XCTAssertNotNil(r)
    }
    XCTAssertEqual(CAtomicsIsLockFree(&a), true)

    i = UInt.randomPositive()
    u = Unmanaged.passRetained(Witness(i))
    XCTAssertNil(CAtomicsExchange(&a, u.toOpaque(), .release))
    print("Releasing \(i)")
    let p = CAtomicsExchange(&a, nil, .acquire)
    XCTAssertNotNil(p)
    _ = p.map(Unmanaged<Witness>.fromOpaque)?.takeRetainedValue()

    i = UInt.randomPositive()
    u = Unmanaged.passRetained(Witness(i))
    XCTAssertEqual(CAtomicsCompareAndExchange(&a, nil, u.toOpaque(), .strong, .release), true)
    XCTAssertEqual(CAtomicsCompareAndExchange(&a, nil, u.toOpaque(), .weak, .relaxed), false)

    let v = CAtomicsExchange(&a, nil, .acquire)
    XCTAssertNotNil(v)
    XCTAssertEqual(v, UnsafeRawPointer(u.toOpaque()))
    XCTAssertEqual(CAtomicsLoad(&a, .relaxed), nil)
    CAtomicsExchange(&a, v, .release)

    let j = UInt.randomPositive()
    u = Unmanaged.passRetained(Witness(j))
    XCTAssertFalse(CAtomicsCompareAndExchange(&a, nil, u.toOpaque(), .strong, .relaxed))
    XCTAssertTrue( CAtomicsCompareAndExchange(&a, v, u.toOpaque(), .strong, .relaxed))
    print("Releasing \(i)")
    v.map(Unmanaged<Witness>.fromOpaque)?.release()
    while !CAtomicsCompareAndExchange(&a, u.toOpaque(), nil, .weak, .relaxed) {}
    print("Releasing \(j)")
    u.release()
  }

}

private let iterations = 200_000//_000

public class UnmanagedRaceTests: XCTestCase
{
  public func testRaceAtomicUnmanaged()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var r = OpaqueUnmanagedHelper()
      CAtomicsInitialize(&r, {
        () -> UnsafeMutableRawPointer in
        let b = ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 })
        let u = Unmanaged.passRetained(b)
        return u.toOpaque()
      }())
      let closure = {
        while true
        {
          if let p = CAtomicsExchange(&r, nil, .relaxed)
          {
            let buffer = Unmanaged<ManagedBuffer<Int, Int>>.fromOpaque(p).takeRetainedValue()
            XCTAssertEqual(buffer.header, 1)
          }
          else
          {
            XCTAssertNil(CAtomicsExchange(&r,nil, .relaxed))
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
