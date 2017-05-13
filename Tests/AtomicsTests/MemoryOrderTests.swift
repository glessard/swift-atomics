//
//  MemoryOrderTests.swift
//  Atomics
//
//  Created by Guillaume Lessard on 5/13/17.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//

import XCTest

import ClangAtomics
import Atomics

class MemoryOrderTests: XCTestCase
{
  static var allTests = [
    ("testMemoryOrder", testMemoryOrder),
  ]

  func testMemoryOrder()
  {
    let m = MemoryOrder(rawValue: memory_order_relaxed.rawValue)
    XCTAssert(m == .relaxed)

    XCTAssert(MemoryOrder.relaxed.rawValue == memory_order_relaxed.rawValue)
    XCTAssert(MemoryOrder.acquire.rawValue == memory_order_acquire.rawValue)
    XCTAssert(MemoryOrder.release.rawValue == memory_order_release.rawValue)
    XCTAssert(MemoryOrder.acqrel.rawValue  == memory_order_acq_rel.rawValue)
    XCTAssert(MemoryOrder.sequential.rawValue == memory_order_seq_cst.rawValue)

    XCTAssert(LoadMemoryOrder.relaxed.rawValue == memory_order_relaxed.rawValue)
    XCTAssert(LoadMemoryOrder.acquire.rawValue == memory_order_acquire.rawValue)
    XCTAssert(LoadMemoryOrder.sequential.rawValue == memory_order_seq_cst.rawValue)

    XCTAssert(StoreMemoryOrder.relaxed.rawValue == memory_order_relaxed.rawValue)
    XCTAssert(StoreMemoryOrder.release.rawValue == memory_order_release.rawValue)
    XCTAssert(StoreMemoryOrder.sequential.rawValue == memory_order_seq_cst.rawValue)

    XCTAssert(LoadMemoryOrder.relaxed.rawValue < MemoryOrder.release.rawValue)
  }
}
