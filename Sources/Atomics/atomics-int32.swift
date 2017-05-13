//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt32
{
  @_versioned internal var val = Atomic32()
  public init(_ value: Int32 = 0)
  {
    Atomic32Init(value, &val)
  }

  public var value: Int32 {
    @inline(__always)
    mutating get { return Atomic32Load(&val, .relaxed) }
  }
}

extension AtomicInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    Atomic32Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Atomic32And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return Atomic32StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return Atomic32WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int32, future: Int32,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
