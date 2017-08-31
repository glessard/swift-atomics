//
//  CAtomicsRaceTests.swift
//  AtomicsTests
//
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import XCTest
import Dispatch

import CAtomics

private let iterations = 200_000//_000

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

public class CAtomicsRaceTests: XCTestCase
{
  public static var allTests = [
    ("testRaceCrash", testRaceCrash),
    ("testRaceSpinLock", testRaceSpinLock),
    ("testRacePointerCAS", testRacePointerCAS),
    ("testRacePointerSwap", testRacePointerSwap),
  ]

  public func testRaceCrash()
  {
#if false
    // this version is guaranteed to crash with a double-free
    let q = DispatchQueue(label: "", attributes: .concurrent)
    for _ in 1...iterations
    {
      var p: Optional = UnsafeMutablePointer<Point>.allocate(capacity: 1)

      let closure = {
        while true
        {
          if let c = p
          {
            p = nil
            c.deallocate(capacity: 1)
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
#else
    print("double-free crash disabled")
#endif
  }

  public func testRaceSpinLock()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p: Optional = UnsafeMutablePointer<Point>.allocate(capacity: 1)
      var lock = CAtomicsInt()
      CAtomicsIntInit(0, &lock)

      let closure = {
        while true
        {
          var current = 0
          if CAtomicsIntCAS(&current, 1, &lock, .weak, .sequential, .relaxed)
          {
            defer { CAtomicsIntStore(0, &lock, .sequential) }
            if let c = p
            {
              p = nil
              c.deallocate(capacity: 1)
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
      var p = CAtomicsPointer()
      CAtomicsPointerInit(UnsafeMutablePointer<Point>.allocate(capacity: 1), &p)

      let closure = {
        var c = UnsafeRawPointer(bitPattern: 0x1)
        while true
        {
          if CAtomicsPointerCAS(&c, nil, &p, .weak, .release, .relaxed)
          {
            if let c = UnsafeMutableRawPointer(mutating: c)
            {
              let pointer = c.assumingMemoryBound(to: Point.self)
              pointer.deallocate(capacity: 1)
            }
          }

          if c == nil
          { // pointer is deallocated
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
      var p = CAtomicsPointer()
      CAtomicsPointerInit(UnsafeMutablePointer<Point>.allocate(capacity: 1), &p)

      let closure = {
        while true
        {
          if let c = CAtomicsPointerSwap(nil, &p, .acquire)
          {
            let pointer = UnsafeMutableRawPointer(mutating: c).assumingMemoryBound(to: Point.self)
            pointer.deallocate(capacity: 1)
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

