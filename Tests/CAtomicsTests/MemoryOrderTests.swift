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
    XCTAssertEqual(m, .relaxed)

    XCTAssertEqual(MemoryOrder.relaxed.rawValue, memory_order_relaxed.rawValue)
    XCTAssertEqual(MemoryOrder.acquire.rawValue, memory_order_acquire.rawValue)
    XCTAssertEqual(MemoryOrder.release.rawValue, memory_order_release.rawValue)
    XCTAssertEqual(MemoryOrder.acqrel.rawValue , memory_order_acq_rel.rawValue)
    XCTAssertEqual(MemoryOrder.sequential.rawValue, memory_order_seq_cst.rawValue)

    XCTAssertEqual(LoadMemoryOrder.relaxed.rawValue, memory_order_relaxed.rawValue)
    XCTAssertEqual(LoadMemoryOrder.acquire.rawValue, memory_order_acquire.rawValue)
    XCTAssertEqual(LoadMemoryOrder.sequential.rawValue, memory_order_seq_cst.rawValue)

    XCTAssertEqual(StoreMemoryOrder.relaxed.rawValue, memory_order_relaxed.rawValue)
    XCTAssertEqual(StoreMemoryOrder.release.rawValue, memory_order_release.rawValue)
    XCTAssertEqual(StoreMemoryOrder.sequential.rawValue, memory_order_seq_cst.rawValue)

    XCTAssertLessThan(LoadMemoryOrder.relaxed.rawValue, MemoryOrder.release.rawValue)
  }
}
