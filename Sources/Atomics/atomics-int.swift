//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt
{
  @_versioned internal var val = AtomicWord()
  public init(_ value: Int = 0)
  {
    AtomicWordInit(value, &val)
  }

  public var value: Int {
    @inline(__always)
    mutating get { return AtomicWordLoad(&val, .relaxed) }
  }
}

extension AtomicInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return AtomicWordLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    AtomicWordStore(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordAdd(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordAdd(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordSub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordSub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordOr(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordXor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AtomicWordAnd(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return AtomicWordStrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return AtomicWordWeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int, future: Int,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
