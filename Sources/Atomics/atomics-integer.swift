//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

// MARK: Int and UInt Atomics

public struct AtomicInt
{
  @_versioned internal var val = AtomicWord()
  public init(_ value: Int = 0)
  {
    InitWord(value, &val)
  }

  public var value: Int {
    @inline(__always)
    mutating get { return ReadWord(&val, memory_order_relaxed) }
  }
}

extension AtomicInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return ReadWord(&val, order.order)
  }

  @inline(__always)
  public mutating func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(value, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SwapWord(value, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(delta, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(1, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(delta, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(1, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:Int, order: MemoryOrder = .relaxed) -> Int
  {
    return OrWord(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:Int, order: MemoryOrder = .relaxed) -> Int
  {
    return XorWord(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AndWord(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    switch type {
    case .strong:
      return CASWord(current, future, &val, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCASWord(current, future, &val, orderSwap.order, orderLoad.order)
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

public struct AtomicUInt
{
  @_versioned internal var val = AtomicWord()
  public init(_ value: UInt = 0)
  {
    InitWord(Int(bitPattern: value), &val)
  }

  public var value: UInt {
    @inline(__always)
    mutating get { return UInt(bitPattern: ReadWord(&val, memory_order_relaxed)) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: ReadWord(&val, order.order))
  }

  @inline(__always)
  public mutating func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(Int(bitPattern: value), &val, order.order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SwapWord(Int(bitPattern: value), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AddWord(Int(bitPattern: delta), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AddWord(1, &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SubWord(Int(bitPattern: delta), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SubWord(1, &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: OrWord(Int(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: XorWord(Int(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AndWord(Int(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    return current.withMemoryRebound(to: Int.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CASWord(current, Int(bitPattern: future), &val, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCASWord(current, Int(bitPattern: future), &val, orderSwap.order, orderLoad.order)
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

// MARK: Int32 and UInt32 Atomics

public struct AtomicInt32
{
  @_versioned internal var val = Atomic32()
  public init(_ value: Int32 = 0)
  {
    Init32(value, &val)
  }

  public var value: Int32 {
    @inline(__always)
    mutating get { return Read32(&val, memory_order_relaxed) }
  }
}

extension AtomicInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return Read32(&val, order.order)
  }

  @inline(__always)
  public mutating func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    Store32(value, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Swap32(value, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Add32(delta, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return Add32(1, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Sub32(delta, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return Sub32(1, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Or32(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Xor32(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return And32(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    switch type {
    case .strong:
      return CAS32(current, future, &val, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCAS32(current, future, &val, orderSwap.order, orderLoad.order)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int32, future: Int32,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt32
{
  @_versioned internal var val = Atomic32()
  public init(_ value: UInt32 = 0)
  {
    Init32(Int32(bitPattern: value), &val)
  }

  public var value: UInt32 {
    @inline(__always)
    mutating get { return UInt32(bitPattern: Read32(&val, memory_order_relaxed)) }
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Read32(&val, order.order))
  }

  @inline(__always)
  public mutating func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    Store32(Int32(bitPattern: value), &val, order.order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Swap32(Int32(bitPattern: value), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Add32(Int32(bitPattern: delta), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Add32(1, &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Sub32(Int32(bitPattern: delta), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Sub32(1, &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Or32(Int32(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: Xor32(Int32(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return UInt32(bitPattern: And32(Int32(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    return current.withMemoryRebound(to: Int32.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAS32(current, Int32(bitPattern: future), &val, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCAS32(current, Int32(bitPattern: future), &val, orderSwap.order, orderLoad.order)
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

// MARK: Int64 and UInt64 Atomics

public struct AtomicInt64
{
  @_versioned internal var val = Atomic64()
  public init(_ value: Int64 = 0)
  {
    Init64(value, &val)
  }

  public var value: Int64 {
    @inline(__always)
    mutating get { return Read64(&val, memory_order_relaxed) }
  }
}

extension AtomicInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return Read64(&val, order.order)
  }

  @inline(__always)
  public mutating func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    Store64(value, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Swap64(value, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Add64(delta, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return Add64(1, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Sub64(delta, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return Sub64(1, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Or64(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Xor64(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return And64(bits, &val, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    switch type {
    case .strong:
      return CAS64(current, future, &val, orderSwap.order, orderLoad.order)
    case .weak:
      return WeakCAS64(current, future, &val, orderSwap.order, orderLoad.order)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int64, future: Int64,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt64
{
  @_versioned internal var val = Atomic64()
  public init(_ value: UInt64 = 0)
  {
    Init64(Int64(bitPattern: value), &val)
  }

  public var value: UInt64 {
    @inline(__always)
    mutating get { return UInt64(bitPattern: Read64(&val, memory_order_relaxed)) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Read64(&val, order.order))
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    Store64(Int64(bitPattern: value), &val, order.order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Swap64(Int64(bitPattern: value), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Add64(Int64(bitPattern: delta), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Add64(1, &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Sub64(Int64(bitPattern: delta), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Sub64(1, &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Or64(Int64(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: Xor64(Int64(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits:UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return UInt64(bitPattern: And64(Int64(bitPattern: bits), &val, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    return current.withMemoryRebound(to: Int64.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAS64(current, Int64(bitPattern: future), &val, orderSwap.order, orderLoad.order)
      case .weak:
        return WeakCAS64(current, Int64(bitPattern: future), &val, orderSwap.order, orderLoad.order)
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
