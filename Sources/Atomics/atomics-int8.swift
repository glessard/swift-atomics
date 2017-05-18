//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt8
{
  @_versioned internal var val = Atomic8()

  public init(_ value: Int8 = 0)
  {
    Atomic8Init(value, &val)
  }

  public var value: Int8 {
    @inline(__always)
    mutating get { return Atomic8Load(&val, .relaxed) }
  }
}

extension AtomicInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    Atomic8Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return Atomic8And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return Atomic8StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return Atomic8WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int8, future: Int8,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
