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

public class ClangAtomicsTests: XCTestCase
{
  public static var allTests = [
    ("testTest", testTest),
  ]

  public func testTest()
  {
    var i = ClangAtomicsSWord()
    ClangAtomicsSWordInit(randomPositive(), &i)
    ClangAtomicsSWordStore(0, &i, .relaxed)
    XCTAssert(ClangAtomicsSWordLoad(&i, .relaxed) == 0)

    let r = randomPositive()
    ClangAtomicsSWordStore(r, &i, .relaxed)
    XCTAssert(ClangAtomicsSWordLoad(&i, .relaxed) == r)
  }
}

public class ClangAtomicsRaceTests: XCTestCase
{
  public static var allTests = [
    ("testRaceSpinLock", testRaceSpinLock),
  ]

  public func testRaceSpinLock()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var p: Optional = UnsafeMutablePointer<Point>.allocate(capacity: 1)
      var lock = ClangAtomicsSWord()
      ClangAtomicsSWordStore(0, &lock, .relaxed)
      let closure = {
        while true
        {
          var current = 0
          if ClangAtomicsSWordWeakCAS(&current, 1, &lock, .sequential, .relaxed)
          {
            defer { ClangAtomicsSWordStore(0, &lock, .sequential) }
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
