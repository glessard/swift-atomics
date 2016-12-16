//
//  memory-order.swift
//  Atomics
//
//  Created by Guillaume Lessard on 01/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public enum MemoryOrder: Int
{
  case relaxed = 0, consume, acquire, release, acqrel, sequential

  public var order: memory_order {
    switch self {
    case .relaxed:    return memory_order_relaxed
    case .consume:    return memory_order_consume
    case .acquire:    return memory_order_acquire
    case .release:    return memory_order_release
    case .acqrel:     return memory_order_acq_rel
    case .sequential: return memory_order_seq_cst
    }
  }
}

public enum LoadMemoryOrder: Int
{
  case relaxed = 0, consume, acquire, sequential = 5

  public var order: memory_order {
    switch self {
    case .relaxed:    return memory_order_relaxed
    case .consume:    return memory_order_consume
    case .acquire:    return memory_order_acquire
    case .sequential: return memory_order_seq_cst
    }
  }
}

public enum StoreMemoryOrder: Int
{
  case relaxed = 0, release = 3, sequential = 5

  public var order: memory_order {
    switch self {
    case .relaxed:    return memory_order_relaxed
    case .release:    return memory_order_release
    case .sequential: return memory_order_seq_cst
    }
  }
}
