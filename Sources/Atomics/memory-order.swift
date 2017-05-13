//
//  memory-order.swift
//  Atomics
//
//  Created by Guillaume Lessard on 01/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

extension MemoryOrder
{
  public static var relaxed:    MemoryOrder { return clang_atomics_memory_order_relaxed }
//public static var consume:    MemoryOrder { return clang_atomics_memory_order_consume }
  public static var acquire:    MemoryOrder { return clang_atomics_memory_order_acquire }
  public static var release:    MemoryOrder { return clang_atomics_memory_order_release }
  public static var acqrel:     MemoryOrder { return clang_atomics_memory_order_acq_rel }
  public static var sequential: MemoryOrder { return clang_atomics_memory_order_seq_cst }
}

extension LoadMemoryOrder
{
  public static var relaxed:    LoadMemoryOrder { return clang_atomics_load_memory_order_relaxed }
//public static var consume:    LoadMemoryOrder { return clang_atomics_load_memory_order_consume }
  public static var acquire:    LoadMemoryOrder { return clang_atomics_load_memory_order_acquire }
  public static var sequential: LoadMemoryOrder { return clang_atomics_load_memory_order_seq_cst }
}

extension StoreMemoryOrder
{
  public static var relaxed:    StoreMemoryOrder { return clang_atomics_store_memory_order_relaxed }
  public static var release:    StoreMemoryOrder { return clang_atomics_store_memory_order_release }
  public static var sequential: StoreMemoryOrder { return clang_atomics_store_memory_order_seq_cst }
}
