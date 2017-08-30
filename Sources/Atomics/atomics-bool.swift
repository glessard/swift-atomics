//
//  atomics-bool.swift
//  Atomics
//
//  Created by Guillaume Lessard on 10/06/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import CAtomics

public struct AtomicBool
{
  @_versioned var val = CAtomicsBoolean()

  public init(_ value: Bool = false)
  {
    CAtomicsBooleanInit(value, &val)
  }

  public var value: Bool {
    @inline(__always)
    mutating get { return CAtomicsBooleanLoad(&val, .relaxed) }
  }
}

extension AtomicBool
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    CAtomicsBooleanStore(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func swap(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func or(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanOr(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func xor(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanXor(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func and(_ value: Bool, order: MemoryOrder = .relaxed)-> Bool
  {
    return CAtomicsBooleanAnd(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Bool>, future: Bool,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return CAtomicsBooleanCAS(current, future, &val, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Bool, future: Bool,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
