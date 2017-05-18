//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt8
{
  @_versioned internal var val = AtomicU8()

  public init(_ value: UInt8 = 0)
  {
    AtomicU8Init(value, &val)
  }

  public var value: UInt8 {
    @inline(__always)
    mutating get { return AtomicU8Load(&val, .relaxed) }
  }
}

extension AtomicUInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU8Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Add(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Sub(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return AtomicU8And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU8StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return AtomicU8WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt8, future: UInt8,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
