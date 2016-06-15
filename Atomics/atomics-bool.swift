//
//  atomics-bool.swift
//  Atomics
//
//  Created by Guillaume Lessard on 10/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import clang_atomics

public struct AtomicBool: BooleanType, BooleanLiteralConvertible
{
  private var val: Int32 = 0
  public init(_ b: Bool = false) { val = b ? 0 : 1 }
  public init(booleanLiteral value: BooleanLiteralType) { val = value ? 0 : 1 }

  public var boolValue: Bool { return val != 0 }

  public var value: Bool {
    mutating get { return Read32(&val, memory_order_relaxed) != 0 }
    mutating set { Store32(newValue ? 0 : 1, &val, memory_order_relaxed) }
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
  public mutating func store(value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    Store32(value ? 0 : 1, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Swap32(value ? 0 : 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func or(value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Or32(value ? 0 : 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func xor(value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return Xor32(value ? 0: 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func and(value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return And32(value ? 0 : 1, &val, order.order) != 0
  }

  @inline(__always)
  public mutating func CAS(current current: Bool, future: Bool,
                                   type: CASType = .strong,
                                   orderSuccess: MemoryOrder = .relaxed,
                                   orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect: Int32 = current ? 0 : 1
    switch type {
    case .strong:
      return CAS32(&expect, future ? 0 : 1, &val, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeak32(&expect, future ? 0 : 1, &val, orderSuccess.order, orderFailure.order)
    }
  }
}

