//
//  ClangAtomicsTests.swift
//  AtomicsTests
//

import XCTest
import Dispatch

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
  import func Darwin.C.stdlib.arc4random
#else // assuming os(Linux)
  import func Glibc.random
#endif

private let iterations = 200_000//_000

private struct Point { var x = 0.0, y = 0.0, z = 0.0 }

func randomPositive() -> Int
{
  // Return a positive Int less than (or equal to) Int32.max/2.
  #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    return Int(arc4random() & 0x7fff_ffff)
  #else
    return Int(random() & 0x7fff_ffff)
  #endif
}


import ClangAtomics

class ClangAtomicsTests: XCTestCase
{
  static var allTests = [
    ("testTest", testTest),
  ]

  func testTest()
  {
    var i = AtomicWord()
    StoreWord(0, &i, memory_order_relaxed)
    XCTAssert(ReadWord(&i, memory_order_relaxed) == 0)

    let r = randomPositive()
    StoreWord(r, &i, memory_order_relaxed)
    XCTAssert(ReadWord(&i, memory_order_relaxed) == r)
  }
}

class ClangAtomicsRaceTests: XCTestCase
{
  static var allTests = [
    ("testRaceSpinLock", testRaceSpinLock),
  ]

  func testRaceSpinLock()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p: Optional = UnsafeMutablePointer<Point>.allocate(capacity: 1)
      var lock = AtomicWord()
      StoreWord(0, &lock, memory_order_relaxed)
      let closure = {
        while true
        {
          var current = 0
          if WeakCASWord(&current, 1, &lock, memory_order_seq_cst, memory_order_relaxed)
          {
            defer { StoreWord(0, &lock, memory_order_seq_cst) }
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
}
