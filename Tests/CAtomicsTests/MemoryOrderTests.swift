//
//  MemoryOrderTests.swift
//  AtomicsTests
//
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import XCTest

import CAtomics

public class MemoryOrderTests: XCTestCase
{
  public func testMemoryOrder()
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
