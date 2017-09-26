//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

public struct AtomicInt
{
  @_versioned var val = CAtomicsInt()

  public init(_ value: Int = 0)
  {
    val.initialize(value)
  }

  public var value: Int {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int, future: Int,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicUInt
{
  @_versioned var val = CAtomicsUInt()

  public init(_ value: UInt = 0)
  {
    val.initialize(value)
  }

  public var value: UInt {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt, future: UInt,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicInt8
{
  @_versioned var val = CAtomicsInt8()

  public init(_ value: Int8 = 0)
  {
    val.initialize(value)
  }

  public var value: Int8 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int8
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int8, future: Int8,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicUInt8
{
  @_versioned var val = CAtomicsUInt8()

  public init(_ value: UInt8 = 0)
  {
    val.initialize(value)
  }

  public var value: UInt8 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicUInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt8
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt8, future: UInt8,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicInt16
{
  @_versioned var val = CAtomicsInt16()

  public init(_ value: Int16 = 0)
  {
    val.initialize(value)
  }

  public var value: Int16 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int16, future: Int16,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicUInt16
{
  @_versioned var val = CAtomicsUInt16()

  public init(_ value: UInt16 = 0)
  {
    val.initialize(value)
  }

  public var value: UInt16 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicUInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt16, future: UInt16,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicInt32
{
  @_versioned var val = CAtomicsInt32()

  public init(_ value: Int32 = 0)
  {
    val.initialize(value)
  }

  public var value: Int32 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int32, future: Int32,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicUInt32
{
  @_versioned var val = CAtomicsUInt32()

  public init(_ value: UInt32 = 0)
  {
    val.initialize(value)
  }

  public var value: UInt32 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt32, future: UInt32,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicInt64
{
  @_versioned var val = CAtomicsInt64()

  public init(_ value: Int64 = 0)
  {
    val.initialize(value)
  }

  public var value: Int64 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int64, future: Int64,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicUInt64
{
  @_versioned var val = CAtomicsUInt64()

  public init(_ value: UInt64 = 0)
  {
    val.initialize(value)
  }

  public var value: UInt64 {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return val.fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt64, future: UInt64,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}

public struct AtomicBool
{
  @_versioned var val = CAtomicsBool()

  public init(_ value: Bool = false)
  {
    val.initialize(value)
  }

  public var value: Bool {
    @inline(__always)
    mutating get { return val.load(.relaxed) }
  }
}

extension AtomicBool
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    val.store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return val.swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func or(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return val.fetch_or(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func xor(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return val.fetch_xor(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func and(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return val.fetch_and(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Bool>, future: Bool,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return val.loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Bool, future: Bool,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return val.CAS(current, future, type, order)
  }
}
