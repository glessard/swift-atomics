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
  @_versioned var val = ClangAtomicsSWord()

  public init(_ value: Int = 0)
  {
    ClangAtomicsSWordInit(value, &val)
  }

  public var value: Int {
    @inline(__always)
    mutating get { return ClangAtomicsSWordLoad(&val, .relaxed) }
  }
}

extension AtomicInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsSWordStore(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordAdd(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordSub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordOr(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordXor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int, order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordAnd(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordAdd(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int
  {
    return ClangAtomicsSWordSub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int>, future: Int,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsSWordStrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsSWordWeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsUWord()

  public init(_ value: UInt = 0)
  {
    ClangAtomicsUWordInit(value, &val)
  }

  public var value: UInt {
    @inline(__always)
    mutating get { return ClangAtomicsUWordLoad(&val, .relaxed) }
  }
}

extension AtomicUInt
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordLoad(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsUWordStore(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordSwap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordAdd(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordSub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordOr(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordXor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt, order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordAnd(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordAdd(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt
  {
    return ClangAtomicsUWordSub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt>, future: UInt,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsUWordStrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsUWordWeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsS8()

  public init(_ value: Int8 = 0)
  {
    ClangAtomicsS8Init(value, &val)
  }

  public var value: Int8 {
    @inline(__always)
    mutating get { return ClangAtomicsS8Load(&val, .relaxed) }
  }
}

extension AtomicInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int8, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS8Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int8, order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int8
  {
    return ClangAtomicsS8Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int8>, future: Int8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS8StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS8WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsU8()

  public init(_ value: UInt8 = 0)
  {
    ClangAtomicsU8Init(value, &val)
  }

  public var value: UInt8 {
    @inline(__always)
    mutating get { return ClangAtomicsU8Load(&val, .relaxed) }
  }
}

extension AtomicUInt8
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt8, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU8Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt8, order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt8
  {
    return ClangAtomicsU8Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt8>, future: UInt8,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU8StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU8WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsS16()

  public init(_ value: Int16 = 0)
  {
    ClangAtomicsS16Init(value, &val)
  }

  public var value: Int16 {
    @inline(__always)
    mutating get { return ClangAtomicsS16Load(&val, .relaxed) }
  }
}

extension AtomicInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int16, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS16Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int16, order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int16
  {
    return ClangAtomicsS16Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int16>, future: Int16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS16StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS16WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsU16()

  public init(_ value: UInt16 = 0)
  {
    ClangAtomicsU16Init(value, &val)
  }

  public var value: UInt16 {
    @inline(__always)
    mutating get { return ClangAtomicsU16Load(&val, .relaxed) }
  }
}

extension AtomicUInt16
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt16, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU16Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt16, order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt16
  {
    return ClangAtomicsU16Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt16>, future: UInt16,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU16StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU16WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsS32()

  public init(_ value: Int32 = 0)
  {
    ClangAtomicsS32Init(value, &val)
  }

  public var value: Int32 {
    @inline(__always)
    mutating get { return ClangAtomicsS32Load(&val, .relaxed) }
  }
}

extension AtomicInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int32, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS32Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int32, order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int32
  {
    return ClangAtomicsS32Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int32>, future: Int32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS32StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS32WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsU32()

  public init(_ value: UInt32 = 0)
  {
    ClangAtomicsU32Init(value, &val)
  }

  public var value: UInt32 {
    @inline(__always)
    mutating get { return ClangAtomicsU32Load(&val, .relaxed) }
  }
}

extension AtomicUInt32
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt32, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU32Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt32, order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt32
  {
    return ClangAtomicsU32Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt32>, future: UInt32,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU32StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU32WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsS64()

  public init(_ value: Int64 = 0)
  {
    ClangAtomicsS64Init(value, &val)
  }

  public var value: Int64 {
    @inline(__always)
    mutating get { return ClangAtomicsS64Load(&val, .relaxed) }
  }
}

extension AtomicInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: Int64, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsS64Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: Int64, order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> Int64
  {
    return ClangAtomicsS64Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<Int64>, future: Int64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsS64StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsS64WeakCAS(current, future, &val, orderSwap, orderLoad)
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
  @_versioned var val = ClangAtomicsU64()

  public init(_ value: UInt64 = 0)
  {
    ClangAtomicsU64Init(value, &val)
  }

  public var value: UInt64 {
    @inline(__always)
    mutating get { return ClangAtomicsU64Load(&val, .relaxed) }
  }
}

extension AtomicUInt64
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Load(&val, order)
  }

  @inline(__always)
  public mutating func store(_ value: UInt64, order: StoreMemoryOrder = .relaxed)
  {
    ClangAtomicsU64Store(value, &val, order)
  }

  @inline(__always)
  public mutating func swap(_ value: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Swap(value, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func add(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Add(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func subtract(_ delta: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Sub(delta, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseOr(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Or(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseXor(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Xor(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func bitwiseAnd(_ bits: UInt64, order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64And(bits, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func increment(order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Add(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func decrement(order: MemoryOrder = .relaxed) -> UInt64
  {
    return ClangAtomicsU64Sub(1, &val, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UInt64>, future: UInt64,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .relaxed,
                               orderLoad: LoadMemoryOrder = .relaxed) -> Bool
  {
    switch type {
    case .strong:
      return ClangAtomicsU64StrongCAS(current, future, &val, orderSwap, orderLoad)
    case .weak:
      return ClangAtomicsU64WeakCAS(current, future, &val, orderSwap, orderLoad)
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
