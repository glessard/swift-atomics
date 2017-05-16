//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicUInt32
{
  @_versioned internal var val = Atomic32()
  public init(_ value: UInt32 = 0)
  {
    Atomic32Init(Int32(bitPattern: value), &val)
  }

  public var value: UInt32 {
    @inline(__always)
    mutating get { return UInt32(bitPattern: Atomic32Load(&val, .relaxed)) }
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Load(&val, order))
  }

  @inline(__always)
  public mutating func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    Atomic32Store(Int32(bitPattern: value), &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Swap(Int32(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func add(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Add(Int32(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Add(1, &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Sub(Int32(bitPattern: value), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Sub(1, &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Or(Int32(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32Xor(Int32(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Atomic32And(Int32(bitPattern: bits), &val, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Int32.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return Atomic32StrongCAS(current, Int32(bitPattern: future), &val, orderSwap, orderLoad)
      case .weak:
        return Atomic32WeakCAS(current, Int32(bitPattern: future), &val, orderSwap, orderLoad)
      }
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt32, future: UInt32,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
