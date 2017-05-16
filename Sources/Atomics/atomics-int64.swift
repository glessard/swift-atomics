//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt64
{
  @_versioned internal var val = Atomic64()
  public init(_ value: Int64 = 0)
  {
    Atomic64Init(value, &val)
  }

  public var value: Int64 {
    @inline(__always)
    mutating get { return Atomic64Load(&val, .relaxed) }
  }
}

extension AtomicInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    Atomic64Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Atomic64And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return Atomic64StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return Atomic64WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int64, future: Int64,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
