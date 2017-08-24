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
    var i = ClangAtomicsInt()
    ClangAtomicsIntInit(randomPositive(), &i)
    ClangAtomicsIntStore(0, &i, .relaxed)
    XCTAssert(ClangAtomicsIntLoad(&i, .relaxed) == 0)

    let r = randomPositive()
    ClangAtomicsIntStore(r, &i, .relaxed)
    XCTAssert(ClangAtomicsIntLoad(&i, .relaxed) == r)
  }
}

