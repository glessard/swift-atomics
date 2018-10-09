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

private let iterations = 200_000//_000

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

private class Thing
{
  let id: UInt
  init(_ x: UInt = UInt.randomPositive()) { id = x }
  deinit { print("Released     \(id)") }
}

public class ReferenceTests: XCTestCase
{
  public func testUnmanaged()
  {
    var i = UInt.randomPositive()
    var a = AtomicReference(Thing(i))
    do {
      let r1 = a.swap(.none)
      print("Will release \(i)")
      XCTAssert(r1 != nil)
    }

    i = UInt.randomPositive()
    XCTAssert(a.swap(Thing(i)) == nil)
    print("Releasing    \(i)")
    XCTAssert(a.swap(nil) != nil)

    i = UInt.randomPositive()
    XCTAssert(a.swapIfNil(Thing(i)) == true)
    let j = UInt.randomPositive()
    print("Will drop    \(j)")
    XCTAssert(a.swapIfNil(Thing(j)) == false)

    print("Will release \(i)")
    XCTAssert(a.take() != nil)
    XCTAssert(a.take() == nil)
  }
}
