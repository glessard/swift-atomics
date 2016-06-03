//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import clang_atomics

// MARK: Int and UInt Atomics

public struct AtomicInt: IntegerLiteralConvertible
{
  private var val: Int = 0
  public init(_ v: Int = 0) { val = v }
  public init(integerLiteral value: IntegerLiteralType) { val = value }

  public var value: Int {
    mutating get { return ReadWord(&val, memory_order_relaxed) }
    mutating set { StoreWord(newValue, &val, memory_order_relaxed) }
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
  public mutating func store(value: Int, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(value, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SwapWord(value, &val, order.order)
  }

  @inline(__always)
  public mutating func add(delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(delta, &val, order.order)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(1, &val, order.order)
  }

  @inline(__always)
  public mutating func subtract(delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(delta, &val, order.order)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(1, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseOr(bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return OrWord(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseXor(bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return XorWord(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseAnd(bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AndWord(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func CAS(current current: Int, future: Int, type: CASType = .strong,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = current
    switch type {
    case .strong:
      return CASWord(&expect, future, &val, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeakWord(&expect, future, &val, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicUInt: IntegerLiteralConvertible
{
  private var val: UInt = 0
  public init(_ v: UInt = 0) { val = v }
  public init(integerLiteral value: IntegerLiteralType) { val = UInt(bitPattern: value) }

  @inline(__always)
  private func ptr(p: UnsafeMutablePointer<UInt>) -> UnsafeMutablePointer<Int>
  {
    return UnsafeMutablePointer<Int>(p)
  }

  public var value: UInt {
    mutating get { return unsafeBitCast(ReadWord(ptr(&val), memory_order_relaxed), UInt.self) }
    mutating set { StoreWord(unsafeBitCast(newValue, Int.self), ptr(&val), memory_order_relaxed) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(ReadWord(ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func store(value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(unsafeBitCast(value, Int.self), ptr(&val), order.order)
  }

  @inline(__always)
  public mutating func swap(value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(SwapWord(unsafeBitCast(value, Int.self), ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func add(delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(AddWord(unsafeBitCast(delta, Int.self), ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(AddWord(1, ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func subtract(delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(SubWord(unsafeBitCast(delta, Int.self), ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(SubWord(1, ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func logicalOr(bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(OrWord(unsafeBitCast(bits, Int.self), ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func logicalXor(bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(XorWord(unsafeBitCast(bits, Int.self), ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func logicalAnd(bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return unsafeBitCast(AndWord(unsafeBitCast(bits, Int.self), ptr(&val), order.order), UInt.self)
  }

  @inline(__always)
  public mutating func CAS(current current: UInt, future: UInt, type: CASType = .strong,
                                   orderSuccess: MemoryOrder = .relaxed,
                                   orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = unsafeBitCast(current, Int.self)
    switch type {
    case .strong:
      return CASWord(&expect, unsafeBitCast(future, Int.self), ptr(&val), orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeakWord(&expect, unsafeBitCast(future, Int.self), ptr(&val), orderSuccess.order, orderFailure.order)
    }
  }
}

// MARK: Int32 and UInt32 Atomics

public struct AtomicInt32: IntegerLiteralConvertible
{
  private var val: Int32 = 0
  public init(_ v: Int32 = 0) { val = v }
  public init(integerLiteral value: IntegerLiteralType) { val = Int32(value) }

  public var value: Int32 {
    mutating get { return Read32(&val, memory_order_relaxed) }
    mutating set { Store32(newValue, &val, memory_order_relaxed) }
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
  public mutating func store(value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    Store32(value, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Swap32(value, &val, order.order)
  }

  @inline(__always)
  public mutating func add(delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Add32(delta, &val, order.order)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return Add32(1, &val, order.order)
  }

  @inline(__always)
  public mutating func subtract(delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Sub32(delta, &val, order.order)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return Sub32(1, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseOr(bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Or32(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseXor(bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return Xor32(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseAnd(bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return And32(bits, &val, order.order)
  }
  
  @inline(__always)
  public mutating func CAS(current current: Int32, future: Int32,
                           type: CASType = .strong,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = current
    switch type {
    case .strong:
      return CAS32(&expect, future, &val, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeak32(&expect, future, &val, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicUInt32: IntegerLiteralConvertible
{
  private var val: UInt32 = 0
  public init(_ v: UInt32 = 0) { val = v }
  public init(integerLiteral value: IntegerLiteralType) { val = UInt32(value) }

  @inline(__always)
  private func ptr(p: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<Int32>
  {
    return UnsafeMutablePointer<Int32>(p)
  }

  public var value: UInt32 {
    mutating get { return unsafeBitCast(Read32(ptr(&val), memory_order_relaxed), UInt32.self) }
    mutating set { Store32(unsafeBitCast(newValue, Int32.self), ptr(&val), memory_order_relaxed) }
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Read32(ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func store(value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    Store32(unsafeBitCast(value, Int32.self), ptr(&val), order.order)
  }

  @inline(__always)
  public mutating func swap(value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Swap32(unsafeBitCast(value, Int32.self), ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func add(delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Add32(unsafeBitCast(delta, Int32.self), ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Add32(1, ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func subtract(delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Sub32(unsafeBitCast(delta, Int32.self), ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Sub32(1, ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func bitwiseOr(bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Or32(unsafeBitCast(bits, Int32.self), ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func bitwiseXor(bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(Xor32(unsafeBitCast(bits, Int32.self), ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func bitwiseAnd(bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return unsafeBitCast(And32(unsafeBitCast(bits, Int32.self), ptr(&val), order.order), UInt32.self)
  }

  @inline(__always)
  public mutating func CAS(current current: UInt32, future: UInt32,
                                   type: CASType = .strong,
                                   orderSuccess: MemoryOrder = .relaxed,
                                   orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = unsafeBitCast(current, Int32.self)
    switch type {
    case .strong:
      return CAS32(&expect, unsafeBitCast(future, Int32.self), ptr(&val), orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeak32(&expect, unsafeBitCast(future, Int32.self), ptr(&val), orderSuccess.order, orderFailure.order)
    }
  }
}

// MARK: Int64 and UInt64 Atomics

public struct AtomicInt64: IntegerLiteralConvertible
{
  private var val: Int64 = 0
  public init(_ v: Int64 = 0) { val = v }
  public init(integerLiteral value: IntegerLiteralType) { val = Int64(value) }

  public var value: Int64 {
    mutating get { return Read64(&val, memory_order_relaxed) }
    mutating set { Store64(newValue, &val, memory_order_relaxed) }
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
  public mutating func store(value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    Store64(value, &val, order.order)
  }

  @inline(__always)
  public mutating func swap(value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Swap64(value, &val, order.order)
  }

  @inline(__always)
  public mutating func add(delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Add64(delta, &val, order.order)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return Add64(1, &val, order.order)
  }

  @inline(__always)
  public mutating func subtract(delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Sub64(delta, &val, order.order)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return Sub64(1, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseOr(bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Or64(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseXor(bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return Xor64(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func bitwiseAnd(bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return And64(bits, &val, order.order)
  }

  @inline(__always)
  public mutating func CAS(current current: Int64, future: Int64,
                                   type: CASType = .strong,
                                   orderSuccess: MemoryOrder = .relaxed,
                                   orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = current
    switch type {
    case .strong:
      return CAS64(&expect, future, &val, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeak64(&expect, future, &val, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicUInt64: IntegerLiteralConvertible
{
  private var val: UInt64 = 0
  public init(_ v: UInt64 = 0) { val = v }
  public init(integerLiteral value: IntegerLiteralType) { val = UInt64(value) }

  @inline(__always)
  private func ptr(p: UnsafeMutablePointer<UInt64>) -> UnsafeMutablePointer<Int64>
  {
    return UnsafeMutablePointer<Int64>(p)
  }

  public var value: UInt64 {
    mutating get { return unsafeBitCast(Read64(ptr(&val), memory_order_relaxed), UInt64.self) }
    mutating set { Store64(unsafeBitCast(newValue, Int64.self), ptr(&val), memory_order_relaxed) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Read64(ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func store(value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    Store64(unsafeBitCast(value, Int64.self), ptr(&val), order.order)
  }

  @inline(__always)
  public mutating func swap(value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Swap64(unsafeBitCast(value, Int64.self), ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func add(delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Add64(unsafeBitCast(delta, Int64.self), ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Add64(1, ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func subtract(delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Sub64(unsafeBitCast(delta, Int64.self), ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Sub64(1, ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func bitwiseOr(bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Or64(unsafeBitCast(bits, Int64.self), ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func bitwiseXor(bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(Xor64(unsafeBitCast(bits, Int64.self), ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func bitwiseAnd(bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return unsafeBitCast(And64(unsafeBitCast(bits, Int64.self), ptr(&val), order.order), UInt64.self)
  }

  @inline(__always)
  public mutating func CAS(current current: UInt64, future: UInt64,
                                   type: CASType = .strong,
                                   orderSuccess: MemoryOrder = .relaxed,
                                   orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = unsafeBitCast(current, Int64.self)
    switch type {
    case .strong:
      return CAS64(&expect, unsafeBitCast(future, Int64.self), ptr(&val), orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeak64(&expect, unsafeBitCast(future, Int64.self), ptr(&val), orderSuccess.order, orderFailure.order)
    }
  }
}
