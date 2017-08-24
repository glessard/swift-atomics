//
//  atomics-integer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 31/05/2016.
//  Copyright © 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicInt
{
  @_versioned var val = ClangAtomicsInt()

  public init(_ value: Int = 0)
  {
    ClangAtomicsIntInit(value, &val)
  }

  public var value: Int {
    @inline(__always)
    mutating get { return ClangAtomicsIntLoad(&val, .relaxed) }
  }
}

extension AtomicInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsIntStore(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntAdd(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntSub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntOr(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntXor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntAnd(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntAdd(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsIntSub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsIntStrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsIntWeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsUInt()

  public init(_ value: UInt = 0)
  {
    ClangAtomicsUIntInit(value, &val)
  }

  public var value: UInt {
    @inline(__always)
    mutating get { return ClangAtomicsUIntLoad(&val, .relaxed) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUIntStore(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntAdd(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntSub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntOr(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntXor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntAnd(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntAdd(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUIntSub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUIntStrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUIntWeakCAS(current, future, &val, orderSwap, orderLoad)
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

public struct AtomicInt8
{
  @_versioned var val = ClangAtomicsInt8()

  public init(_ value: Int8 = 0)
  {
    ClangAtomicsInt8Init(value, &val)
  }

  public var value: Int8 {
    @inline(__always)
    mutating get { return ClangAtomicsInt8Load(&val, .relaxed) }
  }
}

extension AtomicInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsInt8Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsInt8Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsInt8StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsInt8WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int8, future: Int8,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt8
{
  @_versioned var val = ClangAtomicsUInt8()

  public init(_ value: UInt8 = 0)
  {
    ClangAtomicsUInt8Init(value, &val)
  }

  public var value: UInt8 {
    @inline(__always)
    mutating get { return ClangAtomicsUInt8Load(&val, .relaxed) }
  }
}

extension AtomicUInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUInt8Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsUInt8Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUInt8StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUInt8WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt8, future: UInt8,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicInt16
{
  @_versioned var val = ClangAtomicsInt16()

  public init(_ value: Int16 = 0)
  {
    ClangAtomicsInt16Init(value, &val)
  }

  public var value: Int16 {
    @inline(__always)
    mutating get { return ClangAtomicsInt16Load(&val, .relaxed) }
  }
}

extension AtomicInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsInt16Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsInt16Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsInt16StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsInt16WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: Int16, future: Int16,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicUInt16
{
  @_versioned var val = ClangAtomicsUInt16()

  public init(_ value: UInt16 = 0)
  {
    ClangAtomicsUInt16Init(value, &val)
  }

  public var value: UInt16 {
    @inline(__always)
    mutating get { return ClangAtomicsUInt16Load(&val, .relaxed) }
  }
}

extension AtomicUInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUInt16Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsUInt16Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUInt16StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUInt16WeakCAS(current, future, &val, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UInt16, future: UInt16,
                           type: CASType = .weak,
                           order: MemoryOrder = .relaxed) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicInt32
{
  @_versioned var val = ClangAtomicsInt32()

  public init(_ value: Int32 = 0)
  {
    ClangAtomicsInt32Init(value, &val)
  }

  public var value: Int32 {
    @inline(__always)
    mutating get { return ClangAtomicsInt32Load(&val, .relaxed) }
  }
}

extension AtomicInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsInt32Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsInt32Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsInt32StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsInt32WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsUInt32()

  public init(_ value: UInt32 = 0)
  {
    ClangAtomicsUInt32Init(value, &val)
  }

  public var value: UInt32 {
    @inline(__always)
    mutating get { return ClangAtomicsUInt32Load(&val, .relaxed) }
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUInt32Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsUInt32Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUInt32StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUInt32WeakCAS(current, future, &val, orderSwap, orderLoad)
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

public struct AtomicInt64
{
  @_versioned var val = ClangAtomicsInt64()

  public init(_ value: Int64 = 0)
  {
    ClangAtomicsInt64Init(value, &val)
  }

  public var value: Int64 {
    @inline(__always)
    mutating get { return ClangAtomicsInt64Load(&val, .relaxed) }
  }
}

extension AtomicInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsInt64Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsInt64Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsInt64StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsInt64WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsUInt64()

  public init(_ value: UInt64 = 0)
  {
    ClangAtomicsUInt64Init(value, &val)
  }

  public var value: UInt64 {
    @inline(__always)
    mutating get { return ClangAtomicsUInt64Load(&val, .relaxed) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUInt64Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsUInt64Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUInt64StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUInt64WeakCAS(current, future, &val, orderSwap, orderLoad)
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
