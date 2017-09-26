//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

import CAtomics

@_exported import struct CAtomics.AtomicInt

extension AtomicInt
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: Int) after the default initializer, as long as the instance is unshared")
  public init(_ value: Int) {}

  public var value: Int {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int, future: Int,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicUInt

extension AtomicUInt
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: UInt) after the default initializer, as long as the instance is unshared")
  public init(_ value: UInt) {}

  public var value: UInt {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt, future: UInt,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicInt8

extension AtomicInt8
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: Int8) after the default initializer, as long as the instance is unshared")
  public init(_ value: Int8) {}

  public var value: Int8 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int8
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int8, future: Int8,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicUInt8

extension AtomicUInt8
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: UInt8) after the default initializer, as long as the instance is unshared")
  public init(_ value: UInt8) {}

  public var value: UInt8 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt8
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt8, future: UInt8,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicInt16

extension AtomicInt16
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: Int16) after the default initializer, as long as the instance is unshared")
  public init(_ value: Int16) {}

  public var value: Int16 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int16, future: Int16,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicUInt16

extension AtomicUInt16
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: UInt16) after the default initializer, as long as the instance is unshared")
  public init(_ value: UInt16) {}

  public var value: UInt16 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt16, future: UInt16,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicInt32

extension AtomicInt32
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: Int32) after the default initializer, as long as the instance is unshared")
  public init(_ value: Int32) {}

  public var value: Int32 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int32, future: Int32,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicUInt32

extension AtomicUInt32
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: UInt32) after the default initializer, as long as the instance is unshared")
  public init(_ value: UInt32) {}

  public var value: UInt32 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt32, future: UInt32,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicInt64

extension AtomicInt64
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: Int64) after the default initializer, as long as the instance is unshared")
  public init(_ value: Int64) {}

  public var value: Int64 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int64, future: Int64,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicUInt64

extension AtomicUInt64
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: UInt64) after the default initializer, as long as the instance is unshared")
  public init(_ value: UInt64) {}

  public var value: UInt64 {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_add(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_sub(delta, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_or(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_xor(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_and(bits, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_add(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return fetch_sub(1, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt64, future: UInt64,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}

@_exported import struct CAtomics.AtomicBool

extension AtomicBool
{
  @available(*, unavailable, message: "If needed, use initialize(_ value: Bool) after the default initializer, as long as the instance is unshared")
  public init(_ value: Bool) {}

  public var value: Bool {
    @inline(__always)
    mutating get { return load(.relaxed) }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Bool
  {
    return load(order)
  }

  @inline(__always)
  public mutating func store(_ value: Bool, order: StoreMemoryOrder = .relaxed)
  {
    store(value, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return swap(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func or(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return fetch_or(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func xor(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return fetch_xor(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func and(_ value: Bool, order: MemoryOrder = .relaxed) -> Bool
  {
    return fetch_and(value, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Bool>, future: Bool,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    return loadCAS(current, future, type, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Bool, future: Bool,
                           type: CASType = .strong,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    return CAS(current, future, type, order)
  }
}
