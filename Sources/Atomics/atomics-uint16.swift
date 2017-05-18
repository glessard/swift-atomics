//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt16
{
  @_versioned internal var val = AtomicU16()

  public init(_ value: UInt16 = 0)
  {
    AtomicU16Init(value, &val)
  }

  public var value: UInt16 {
    @inline(__always)
    mutating get { return AtomicU16Load(&val, .relaxed) }
  }
}

extension AtomicUInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    AtomicU16Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Add(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Sub(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return AtomicU16And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return AtomicU16StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return AtomicU16WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt16, future: UInt16,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
