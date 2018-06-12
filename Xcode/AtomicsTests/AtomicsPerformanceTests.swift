//
//  AtomicsPerformanceTests.swift
//  AtomicsTests
//
//  Copyright © 2015-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import XCTest
import Atomics

public class AtomicsPerformanceTests: XCTestCase
{
  let testLoopCount = 1_000_000

  public func testPerformanceStore()
  {
    let c = testLoopCount
    var m = AtomicInt()
    measure {
      m.store(0)
      for i in 0..<c { m.store(i, order: .relaxed) }
    }
  }

  public func testPerformanceSynchronizedStore()
  {
    let c = testLoopCount
    var m = AtomicInt()
    measure {
      m.store(0)
      for i in 0..<c { m.store(i, order: .sequential) }
    }
  }

  public func testPerformanceRead()
  {
    let c = testLoopCount
    var m = AtomicInt()
    measure {
      m.store(0)
      for _ in 0..<c { _ = m.load(order: .relaxed) }
    }
  }

  public func testPerformanceSynchronizedRead()
  {
    let c = testLoopCount
    var m = AtomicInt()
    measure {
      m.store(0)
      for _ in 0..<c { _ = m.load(order: .sequential) }
    }
  }

  public func testPerformanceSwiftCASSuccess()
  {
    let c = Int32(testLoopCount)
    var m = AtomicInt32()
    measure {
      m.store(0)
      for i in (m.value)..<c { m.CAS(current: i, future: i&+1) }
    }
  }

  public func testPerformanceOSAtomicCASSuccess()
  {
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      let c = Int32(testLoopCount)
      var m = Int32()
      measure {
        m = 0
        for i in m..<c { OSAtomicCompareAndSwap32(i, i&+1, &m) }
      }
    #else
      print("test not supported on Linux")
    #endif
  }

  public func testPerformanceSwiftCASFailure()
  {
    let c = Int32(testLoopCount)
    var m = AtomicInt32()
    measure {
      m.store(0)
      for i in (m.value)..<c { m.CAS(current: i, future: 0) }
    }
  }

  public func testPerformanceOSAtomicCASFailure()
  {
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      let c = Int32(testLoopCount)
      var m = Int32(0)
      measure {
        m = 0
        for i in m..<c { OSAtomicCompareAndSwap32(i, 0, &m) }
      }
    #else
      print("test not supported on Linux")
    #endif
  }
}
