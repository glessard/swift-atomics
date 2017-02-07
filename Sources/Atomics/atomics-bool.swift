//
//  atomics-bool.swift
//  Atomics
//
//  Created by Guillaume Lessard on 10/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicBool
{
  @_versioned internal var val = Atomic32()
  public init(_ value: Bool = false)
  {
    Store32(value ? 1 : 0, &val, memory_order_relaxed)
  }

  public var value: Bool {
    mutating get { return Read32(&val, memory_order_relaxed) != 0 }
  }
}

extension AtomicBool
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed)-> Bool
  {
    return Read32(&val, order.order) != 0
  }

  @inline(__always)
  public mutating func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    Store32(value ? 1 : 0, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Swap32(value ? 1 : 0, &val, order.order) != 0
  }

  @inline(__always) @discardableResult
  public mutating func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Or32(value ? 1 : 0, &val, order.order) != 0
  }

  @inline(__always) @discardableResult
  public mutating func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Xor32(value ? 1 : 0, &val, order.order) != 0
  }

  @inline(__always) @discardableResult
  public mutating func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return And32(value ? 1 : 0, &val, order.order) != 0
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Bool, future: Bool,
                           type: CASType = .weak,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect: Int32 = current ? 1 : 0
    switch type {
    case .strong:
      return CAS32(&expect, future ? 1 : 0, &val, orderSuccess.order, orderFailure.order)
    case .weak:
      return WeakCAS32(&expect, future ? 1 : 0, &val, orderSuccess.order, orderFailure.order)
    }
  }
}
