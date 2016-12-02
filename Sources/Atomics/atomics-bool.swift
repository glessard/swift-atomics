//
//  atomics-bool.swift
//  Atomics
//
//  Created by Guillaume Lessard on 10/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicBool: ExpressibleByBooleanLiteral
{
  fileprivate var val: Int32 = 0
  public init(_ b: Bool = false) { val = b ? 1 : 0 }
  public init(booleanLiteral value: BooleanLiteralType) { val = value ? 1 : 0 }

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

  @inline(__always)
  public mutating func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Swap32(value ? 0 : 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Or32(value ? 0 : 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Xor32(value ? 0: 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return And32(value ? 0 : 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func CAS(current: Bool, future: Bool,
                           type: CASType = .strong,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect: Int32 = current ? 1 : 0
    switch type {
    case .strong:
      return CAS32(&expect, future ? 1 : 0, &val, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeak32(&expect, future ? 1 : 0, &val, orderSuccess.order, orderFailure.order)
    }
  }
}
