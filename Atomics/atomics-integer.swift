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
    return ReadWord(&self.value, order.order)
  }

  @inline(__always)
  public mutating func store(value: Int, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(value, &self.value, order.order)
  }

  @inline(__always)
  public mutating func swap(value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SwapWord(value, &self.value, order.order)
  }

  @inline(__always)
  public mutating func add(i: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AddWord(i, &self.value, order.order)
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return IncrementWord(&self.value, order.order)
  }

  @inline(__always)
  public mutating func subtract(i: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return SubWord(i, &self.value, order.order)
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return DecrementWord(&self.value, order.order)
  }

  @inline(__always)
  public mutating func bitwiseOr(bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return OrWord(bits, &self.value, order.order)
  }

  @inline(__always)
  public mutating func bitwiseXor(bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return XorWord(bits, &self.value, order.order)
  }

  @inline(__always)
  public mutating func bitwiseAnd(bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return AndWord(bits, &self.value, order.order)
  }

  @inline(__always)
  public mutating func CAS(current current: Int, future: Int,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = current
    return CASWord(&expect, future, &self.value, orderSuccess.order, orderFailure.order)
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
    mutating get { return UInt(bitPattern: ReadWord(ptr(&val), memory_order_relaxed)) }
    mutating set { StoreWord(unsafeBitCast(newValue, Int.self), ptr(&val), memory_order_relaxed) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: ReadWord(ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func store(value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    StoreWord(unsafeBitCast(value, Int.self), ptr(&val), order.order)
  }

  @inline(__always)
  public mutating func swap(value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SwapWord(unsafeBitCast(value, Int.self), ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func add(i: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AddWord(unsafeBitCast(i, Int.self), ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: IncrementWord(ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func subtract(i: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: SubWord(unsafeBitCast(i, Int.self), ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: DecrementWord(ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func logicalOr(bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: OrWord(unsafeBitCast(bits, Int.self), ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func logicalXor(bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: XorWord(unsafeBitCast(bits, Int.self), ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func logicalAnd(bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return UInt(bitPattern: AndWord(unsafeBitCast(bits, Int.self), ptr(&val), order.order))
  }

  @inline(__always)
  public mutating func CAS(current current: UInt, future: UInt,
                                   orderSuccess: MemoryOrder = .relaxed,
                                   orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    precondition(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = current
    return CASWord(ptr(&expect), unsafeBitCast(future, Int.self), ptr(&val), orderSuccess.order, orderFailure.order)
  }
}

// MARK: Int32 and UInt32 Atomics

extension Int32
{
  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> Int32
  {
    return synchronized ? SyncRead32(&self) : Read32(&self)
  }

  @inline(__always) public mutating func atomicStore(v: Int32, synchronized: Bool = true)
  {
    synchronized ? SyncStore32(v, &self) : Store32(v, &self)
  }

  @inline(__always) public mutating func atomicSwap(v: Int32) -> Int32
  {
    return Swap32(v, &self)
  }

  @inline(__always) public mutating func atomicAdd(i: Int32) -> Int32
  {
    return Add32(i, &self)
  }

  @inline(__always) public mutating func increment() -> Int32
  {
    return Increment32(&self)
  }

  @inline(__always) public mutating func atomicSub(i: Int32) -> Int32
  {
    return Sub32(i, &self)
  }

  @inline(__always) public mutating func decrement() -> Int32
  {
    return Decrement32(&self)
  }

  @inline(__always) public mutating func CAS(current current: Int32, future: Int32) -> Bool
  {
    var expect = current
    return CAS32(&expect, future, &self)
    //    if CAS32(&expect, future, &self)
    //    {
    //      precondition(expect == current)
    //    }
    //    else
    //    {
    //      precondition(expect != current)
    //    }
    //    return expect == current
  }
}

extension UInt32
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<Int32>
  {
    return UnsafeMutablePointer<Int32>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UInt32
  {
    return synchronized ? UInt32(bitPattern: SyncRead32(ptr(&self))) : UInt32(bitPattern: Read32(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UInt32, synchronized: Bool = true)
  {
    synchronized ? SyncStore32(unsafeBitCast(v, Int32.self), ptr(&self)) : Store32(unsafeBitCast(v, Int32.self), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UInt32) -> UInt32
  {
    return UInt32(bitPattern: Swap32(unsafeBitCast(v, Int32.self), ptr(&self)))
  }

  @inline(__always) public mutating func atomicAdd(i: UInt32) -> UInt32
  {
    return UInt32(bitPattern: Add32(unsafeBitCast(i, Int32.self), ptr(&self)))
  }

  @inline(__always) public mutating func increment() -> UInt32
  {
    return UInt32(bitPattern: Increment32(ptr(&self)))
  }

  @inline(__always) public mutating func atomicSub(i: UInt32) -> UInt32
  {
    return UInt32(bitPattern: Sub32(unsafeBitCast(i, Int32.self), ptr(&self)))
  }

  @inline(__always) public mutating func decrement() -> UInt32
  {
    return UInt32(bitPattern: Decrement32(ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UInt32, future: UInt32) -> Bool
  {
    var expect = current
    return CAS32(ptr(&expect), unsafeBitCast(future, Int32.self), ptr(&self))
  }
}

// MARK: Int64 and UInt64 Atomics

extension Int64
{
  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> Int64
  {
    return synchronized ? SyncRead64(&self) : Read64(&self)
  }

  @inline(__always) public mutating func atomicStore(v: Int64, synchronized: Bool = true)
  {
    synchronized ? SyncStore64(v, &self) : Store64(v, &self)
  }

  @inline(__always) public mutating func atomicSwap(v: Int64) -> Int64
  {
    return Swap64(v, &self)
  }

  @inline(__always) public mutating func atomicAdd(i: Int64) -> Int64
  {
    return Add64(i, &self)
  }

  @inline(__always) public mutating func increment() -> Int64
  {
    return Increment64(&self)
  }

  @inline(__always) public mutating func atomicSub(i: Int64) -> Int64
  {
    return Sub64(i, &self)
  }

  @inline(__always) public mutating func decrement() -> Int64
  {
    return Decrement64(&self)
  }

  @inline(__always) public mutating func CAS(current current: Int64, future: Int64) -> Bool
  {
    var expect = current
    return CAS64(&expect, future, &self)
  }
}

extension UInt64
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UInt64>) -> UnsafeMutablePointer<Int64>
  {
    return UnsafeMutablePointer<Int64>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UInt64
  {
    return synchronized ? UInt64(bitPattern: SyncRead64(ptr(&self))) : UInt64(bitPattern: Read64(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UInt64, synchronized: Bool = true)
  {
    synchronized ? SyncStore64(unsafeBitCast(v, Int64.self), ptr(&self)) : Store64(unsafeBitCast(v, Int64.self), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UInt64) -> UInt64
  {
    return UInt64(bitPattern: Swap64(unsafeBitCast(v, Int64.self), ptr(&self)))
  }

  @inline(__always) public mutating func atomicAdd(i: UInt64) -> UInt64
  {
    return UInt64(bitPattern: Add64(unsafeBitCast(i, Int64.self), ptr(&self)))
  }

  @inline(__always) public mutating func increment() -> UInt64
  {
    return UInt64(bitPattern: Increment64(ptr(&self)))
  }

  @inline(__always) public mutating func atomicSub(i: UInt64) -> UInt64
  {
    return UInt64(bitPattern: Sub64(unsafeBitCast(i, Int64.self), ptr(&self)))
  }

  @inline(__always) public mutating func decrement() -> UInt64
  {
    return UInt64(bitPattern: Decrement64(ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UInt64, future: UInt64) -> Bool
  {
    var expect = current
    return CAS64(ptr(&expect), unsafeBitCast(future, Int64.self), ptr(&self))
  }
}
