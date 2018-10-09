//
//  AtomicsRaceTests.swift
//  AtomicsTests
//
//  Copyright © 2015-2018 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import XCTest
import Dispatch

import Atomics

private let iterations = 200_000//_000

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

public class AtomicsRaceTests: XCTestCase
{
  public func testRaceCrash()
  { // this version is guaranteed to crash with a double-free
    let q = DispatchQueue(label: "", attributes: .concurrent)

  #if false
    for _ in 1...iterations
    {
      var p: Optional = UnsafeMutablePointer<Point>.allocate(capacity: 1)
      let closure = {
        while true
        {
          if let c = p
          {
            p = nil
            #if swift(>=4.1)
            c.deallocate()
            #else
            c.deallocate(capacity: 1)
            #endif
          }
          else // pointer is deallocated
          {
            break
          }
        }
      }

      q.async(execute: closure)
      q.async(execute: closure)
    }
  #else
    print("double-free crash disabled")
  #endif

    q.sync(flags: .barrier) {}
  }

  public func testRaceSpinLock()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p: Optional = UnsafeMutablePointer<Point>.allocate(capacity: 1)
      var lock = AtomicInt()
      let closure = {
        while true
        {
          if lock.CAS(current: 0, future: 1, type: .weak, order: .acquire)
          {
            defer { lock.store(0, order: .release) }
            if let c = p
            {
              p = nil
              #if swift(>=4.1)
              c.deallocate()
              #else
              c.deallocate(capacity: 1)
              #endif
            }
            else // pointer is deallocated
            {
              break
            }
          }
        }
      }

      q.async(execute: closure)
      q.async(execute: closure)
    }

    q.sync(flags: .barrier) {}
  }

  public func testRacePointerCAS()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p = AtomicMutablePointer(UnsafeMutablePointer<Point>.allocate(capacity: 1))
      let closure = {
        while true
        {
          if let c = p.load(order: .acquire)
          {
            if p.CAS(current: c, future: nil, type: .weak, order: .release)
            {
              #if swift(>=4.1)
              c.deallocate()
              #else
              c.deallocate(capacity: 1)
              #endif
            }
          }
          else // pointer is deallocated
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

  public func testRacePointerLoadCAS()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p = AtomicMutablePointer(UnsafeMutablePointer<Point>.allocate(capacity: 1))
      let closure = {
        var c = p.pointer
        while true
        {
          if p.loadCAS(current: &c, future: nil, type: .weak, orderSwap: .release, orderLoad: .relaxed),
             let c = c
          {
            #if swift(>=4.1)
            c.deallocate()
            #else
            c.deallocate(capacity: 1)
            #endif
          }
          else // pointer is deallocated
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

  public func testRacePointerSwap()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p = AtomicMutablePointer(UnsafeMutablePointer<Point>.allocate(capacity: 1))
      let closure = {
        while true
        {
          if let c = p.swap(nil, order: .acquire)
          {
            #if swift(>=4.1)
            c.deallocate()
            #else
            c.deallocate(capacity: 1)
            #endif
          }
          else // pointer is deallocated
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
