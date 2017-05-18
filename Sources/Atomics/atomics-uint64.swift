//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt64
{
  @_versioned internal var val = AtomicU64()

  public init(_ value: UInt64 = 0)
  {
    AtomicU64Init(value, &val)
  }

  public var value: UInt64 {
    @inline(__always)
    mutating get { return AtomicU64Load(&val, .relaxed) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU64Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Add(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Sub(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return AtomicU64And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU64StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return AtomicU64WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt64, future: UInt64,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
