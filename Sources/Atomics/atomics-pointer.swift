//
//  atomics-pointer.swift
//  Atomics
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

@_exported import enum CAtomics.MemoryOrder
@_exported import enum CAtomics.LoadMemoryOrder
@_exported import enum CAtomics.StoreMemoryOrder
@_exported import enum CAtomics.CASType
import CAtomics

public struct AtomicNonNullPointer<Pointee>
{
#if swift(>=4.2)
  @usableFromInline var ptr = AtomicNonNullRawPointer()
#else
  @_versioned var ptr = AtomicNonNullRawPointer()
#endif

  public init(_ pointer: UnsafePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, UnsafeRawPointer(pointer))
  }

  public mutating func initialize(_ pointer: UnsafePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, UnsafeRawPointer(pointer))
  }

#if swift(>=4.2)
  public var pointer: UnsafePointer<Pointee> {
    @inlinable
    mutating get {
      return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed).assumingMemoryBound(to: Pointee.self))
    }
  }
#else
  public var pointer: UnsafePointer<Pointee> {
    @inline(__always)
    mutating get {
      return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed).assumingMemoryBound(to: Pointee.self))
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>
  {
    return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>
  {
    return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafePointer<Pointee>, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeRawPointer(pointer), order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeRawPointer(pointer), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafePointer<Pointee>, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>
  {
    return UnsafePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeRawPointer(pointer), order).assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>
  {
    return UnsafePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeRawPointer(pointer), order).assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>>,
                               future: UnsafePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeRawPointer).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>>,
                               future: UnsafePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeRawPointer).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func CAS(current: UnsafePointer<Pointee>, future: UnsafePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>, future: UnsafePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#endif
}

public struct AtomicNonNullMutablePointer<Pointee>
{
#if swift(>=4.2)
  @usableFromInline var ptr = AtomicNonNullMutableRawPointer()
#else
  @_versioned var ptr = AtomicNonNullMutableRawPointer()
#endif

  public init(_ pointer: UnsafeMutablePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, UnsafeMutableRawPointer(pointer))
  }

  public mutating func initialize(_ pointer: UnsafeMutablePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, UnsafeMutableRawPointer(pointer))
  }

#if swift(>=4.2)
  public var pointer: UnsafeMutablePointer<Pointee> {
    @inlinable
    mutating get {
      return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed).assumingMemoryBound(to: Pointee.self))
    }
  }
#else
  public var pointer: UnsafeMutablePointer<Pointee> {
    @inline(__always)
    mutating get {
      return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed).assumingMemoryBound(to: Pointee.self))
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeMutableRawPointer(pointer), order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeMutableRawPointer(pointer), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeMutableRawPointer(pointer), order).assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeMutableRawPointer(pointer), order).assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>>,
                               future: UnsafeMutablePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeMutableRawPointer).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeMutableRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>>,
                               future: UnsafeMutablePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeMutableRawPointer).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeMutableRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>, future: UnsafeMutablePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>, future: UnsafeMutablePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#endif
}

public struct AtomicOptionalPointer<Pointee>
{
#if swift(>=4.2)
  @usableFromInline var ptr = AtomicOptionalRawPointer()
#else
  @_versioned var ptr = AtomicOptionalRawPointer()
#endif

  public init()
  {
    CAtomicsInitialize(&ptr, nil)
  }

  public init(_ pointer: UnsafePointer<Pointee>?)
  {
    CAtomicsInitialize(&ptr, UnsafeRawPointer(pointer))
  }

  public mutating func initialize(_ pointer: UnsafePointer<Pointee>?)
  {
    CAtomicsInitialize(&ptr, UnsafeRawPointer(pointer))
  }

#if swift(>=4.2)
  public var pointer: UnsafePointer<Pointee>? {
    @inlinable
    mutating get {
      return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }
#else
  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeRawPointer(pointer), order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeRawPointer(pointer), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeRawPointer(pointer), order)?.assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeRawPointer(pointer), order)?.assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                               future: UnsafePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeRawPointer?).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                               future: UnsafePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeRawPointer?).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#endif
}

public struct AtomicOptionalMutablePointer<Pointee>
{
#if swift(>=4.2)
  @usableFromInline var ptr = AtomicOptionalMutableRawPointer()
#else
  @_versioned var ptr = AtomicOptionalMutableRawPointer()
#endif

  public init()
  {
    CAtomicsInitialize(&ptr, nil)
  }

  public init(_ pointer: UnsafeMutablePointer<Pointee>?)
  {
    CAtomicsInitialize(&ptr, UnsafeMutableRawPointer(pointer))
  }

  public mutating func initialize(_ pointer: UnsafeMutablePointer<Pointee>?)
  {
    CAtomicsInitialize(&ptr, UnsafeMutableRawPointer(pointer))
  }

#if swift(>=4.2)
  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inlinable
    mutating get {
      return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }
#else
  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeMutableRawPointer(pointer), order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&ptr, UnsafeMutableRawPointer(pointer), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeMutableRawPointer(pointer), order)?.assumingMemoryBound(to: Pointee.self))
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsExchange(&ptr, UnsafeMutableRawPointer(pointer), order)?.assumingMemoryBound(to: Pointee.self))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                               future: UnsafeMutablePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeMutableRawPointer?).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeMutableRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                               future: UnsafeMutablePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: (UnsafeMutableRawPointer?).self, capacity: 1) {
      CAtomicsCompareAndExchange(&ptr, $0, UnsafeMutableRawPointer(future), type, orderSwap, orderLoad)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&ptr, current, future, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicNonNullRawPointer

extension AtomicNonNullRawPointer
{
#if swift(>=4.2)
  public var pointer: UnsafeRawPointer {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#else
  public var pointer: UnsafeRawPointer {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ pointer: UnsafeRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }
#else
  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer
  {
    return CAtomicsLoad(&self, order)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer
  {
    return CAtomicsLoad(&self, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafeRawPointer, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafeRawPointer, order: MemoryOrder = .sequential) -> UnsafeRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer, order: MemoryOrder = .sequential) -> UnsafeRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer>,
                               future: UnsafeRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer>,
                               future: UnsafeRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeRawPointer, future: UnsafeRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeRawPointer, future: UnsafeRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicOptionalRawPointer

extension AtomicOptionalRawPointer
{
#if swift(>=4.2)
  public var pointer: UnsafeRawPointer? {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#else
  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ pointer: UnsafeRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }
#else
  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                               future: UnsafeRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                               future: UnsafeRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicNonNullMutableRawPointer

extension AtomicNonNullMutableRawPointer
{
#if swift(>=4.2)
  public var pointer: UnsafeMutableRawPointer {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#else
  public var pointer: UnsafeMutableRawPointer {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }
#else
  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer
  {
    return CAtomicsLoad(&self, order)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer
  {
    return CAtomicsLoad(&self, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafeMutableRawPointer, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafeMutableRawPointer, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer>,
                               future: UnsafeMutableRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer>,
                               future: UnsafeMutableRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer, future: UnsafeMutableRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer, future: UnsafeMutableRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicOptionalMutableRawPointer

extension AtomicOptionalMutableRawPointer
{
#if swift(>=4.2)
  public var pointer: UnsafeMutableRawPointer? {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#else
  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }
#else
  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                               future: UnsafeMutableRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                               future: UnsafeMutableRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicNonNullOpaquePointer

extension AtomicNonNullOpaquePointer
{
#if swift(>=4.2)
  public var pointer: OpaquePointer {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#else
  public var pointer: OpaquePointer {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ pointer: OpaquePointer)
  {
    CAtomicsInitialize(&self, pointer)
  }
#else
  @inline(__always)
  public mutating func initialize(_ pointer: OpaquePointer)
  {
    CAtomicsInitialize(&self, pointer)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer
  {
    return CAtomicsLoad(&self, order)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer
  {
    return CAtomicsLoad(&self, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: OpaquePointer, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: OpaquePointer, order: MemoryOrder = .sequential) -> OpaquePointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer, order: MemoryOrder = .sequential) -> OpaquePointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<OpaquePointer>,
                               future: OpaquePointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<OpaquePointer>,
                               future: OpaquePointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: OpaquePointer, future: OpaquePointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer, future: OpaquePointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicOptionalOpaquePointer

extension AtomicOptionalOpaquePointer
{
#if swift(>=4.2)
  public var pointer: OpaquePointer? {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#else
  public var pointer: OpaquePointer? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .relaxed)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ pointer: OpaquePointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }
#else
  @inline(__always)
  public mutating func initialize(_ pointer: OpaquePointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return CAtomicsLoad(&self, order)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return CAtomicsLoad(&self, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsStore(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#else
  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                               future: OpaquePointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                               future: OpaquePointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, orderSwap, orderLoad)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    return CAtomicsCompareAndExchange(&self, current, future, type, order)
  }
#endif
}

@available(*, unavailable, renamed: "AtomicOptionalPointer")
public typealias AtomicPointer<T> = AtomicOptionalPointer<T>

@available(*, unavailable, renamed: "AtomicOptionalMutablePointer")
public typealias AtomicMutablePointer<T> = AtomicOptionalMutablePointer<T>

@available(*, unavailable, renamed: "AtomicOptionalRawPointer")
public typealias AtomicRawPointer = AtomicOptionalRawPointer

@available(*, unavailable, renamed: "AtomicOptionalMutableRawPointer")
public typealias AtomicMutableRawPointer = AtomicOptionalMutableRawPointer

@available(*, unavailable, renamed: "AtomicOptionalOpaquePointer")
public typealias AtomicOpaquePointer = AtomicOptionalOpaquePointer
