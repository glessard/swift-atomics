//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt16
{
  @_versioned internal var val = Atomic16()

  public init(_ value: Int16 = 0)
  {
    Atomic16Init(value, &val)
  }

  public var value: Int16 {
    @inline(__always)
    mutating get { return Atomic16Load(&val, .relaxed) }
  }
}

extension AtomicInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    Atomic16Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return Atomic16And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return Atomic16StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return Atomic16WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int16, future: Int16,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
