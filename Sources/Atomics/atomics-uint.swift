//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt
{
  @_versioned internal var val = AtomicWord()
  public init(_ value: UInt = 0)
  {
    AtomicWordInit(Int(bitPattern: value), &val)
  }

  public var value: UInt {
    @inline(__always)
    mutating get { return UInt(bitPattern: AtomicWordLoad(&val, .relaxed)) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordLoad(&val, order))
  }

  @inline(__always)
  public mutating func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    AtomicWordStore(Int(bitPattern: value), &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordSwap(Int(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func add(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordAdd(Int(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordAdd(1, &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordSub(Int(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordSub(1, &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordOr(Int(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordXor(Int(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AtomicWordAnd(Int(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Int.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicWordStrongCAS(current, Int(bitPattern: future), &val, orderSwap, orderLoad)
      case .weak:
        return AtomicWordWeakCAS(current, Int(bitPattern: future), &val, orderSwap, orderLoad)
      }
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt, future: UInt,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
