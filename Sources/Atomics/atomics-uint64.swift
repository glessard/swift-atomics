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
  @_versioned internal var val = Atomic64()

  public init(_ value: UInt64 = 0)
  {
    Atomic64Init(Int64(bitPattern: value), &val)
  }

  public var value: UInt64 {
    @inline(__always)
    mutating get { return UInt64(bitPattern: Atomic64Load(&val, .relaxed)) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Load(&val, order))
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    Atomic64Store(Int64(bitPattern: value), &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Swap(Int64(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func add(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Add(Int64(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Add(1, &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Sub(Int64(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Sub(1, &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Or(Int64(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64Xor(Int64(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Atomic64And(Int64(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Int64.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return Atomic64StrongCAS(current, Int64(bitPattern: future), &val, orderSwap, orderLoad)
      case .weak:
        return Atomic64WeakCAS(current, Int64(bitPattern: future), &val, orderSwap, orderLoad)
      }
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
