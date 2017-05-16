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
  @_versioned internal var val = AtomicBoolean()

  public init(_ value: Bool = false)
  {
    AtomicBooleanInit(value, &val)
  }

  public var value: Bool {
    @inline(__always)
    mutating get { return AtomicBooleanLoad(&val, .relaxed) }
  }
}

extension AtomicBool
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    AtomicBooleanStore(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanOr(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanXor(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return AtomicBooleanAnd(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Bool, future: Bool,
                           type: CASType = .weak,
                           orderSwap: MemoryOrder = .relaxed,
                           orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    var expect = current
    switch type {
    case .strong:
      return AtomicBooleanStrongCAS(&expect, future, &val, orderSwap, orderLoad)
    case .weak:
      return AtomicBooleanWeakCAS(&expect, future, &val, orderSwap, orderLoad)
    }
  }
}
