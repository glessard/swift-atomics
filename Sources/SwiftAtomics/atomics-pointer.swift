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

public struct AtomicPointer<Pointee>
{
#if swift(>=4.2)
  @usableFromInline var ptr = AtomicRawPointer()
#else
  @_versioned var ptr = AtomicRawPointer()
#endif

  public init(_ pointer: UnsafePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, pointer)
  }

  public mutating func initialize(_ pointer: UnsafePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, pointer)
  }

#if swift(>=4.2)
  public var pointer: UnsafePointer<Pointee> {
    @inlinable
    mutating get {
      return CAtomicsLoad(&ptr, .acquire).assumingMemoryBound(to: Pointee.self)
    }
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafePointer<Pointee>
  {
    return CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafePointer<Pointee>, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafePointer<Pointee>, order: MemoryOrder = .acqrel) -> UnsafePointer<Pointee>
  {
    return CAtomicsExchange(&ptr, pointer, order).assumingMemoryBound(to: Pointee.self)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafePointer<Pointee>,
                               future: UnsafePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>, future: UnsafePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafePointer<Pointee> {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&ptr, .acquire).assumingMemoryBound(to: Pointee.self)
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafePointer<Pointee>
  {
    return CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>, order: MemoryOrder = .acqrel) -> UnsafePointer<Pointee>
  {
    return CAtomicsExchange(&ptr, pointer, order).assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafePointer<Pointee>,
                               future: UnsafePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>, future: UnsafePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#endif
}

public struct AtomicMutablePointer<Pointee>
{
#if swift(>=4.2)
  @usableFromInline var ptr = AtomicMutableRawPointer()
#else
  @_versioned var ptr = AtomicMutableRawPointer()
#endif

  public init(_ pointer: UnsafeMutablePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, pointer)
  }

  public mutating func initialize(_ pointer: UnsafeMutablePointer<Pointee>)
  {
    CAtomicsInitialize(&ptr, pointer)
  }

#if swift(>=4.2)
  public var pointer: UnsafeMutablePointer<Pointee> {
    @inlinable
    mutating get {
      return CAtomicsLoad(&ptr, .acquire).assumingMemoryBound(to: Pointee.self)
    }
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutablePointer<Pointee>
  {
    return CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>, order: MemoryOrder = .acqrel) -> UnsafeMutablePointer<Pointee>
  {
    return CAtomicsExchange(&ptr, pointer, order).assumingMemoryBound(to: Pointee.self)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutablePointer<Pointee>,
                               future: UnsafeMutablePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeMutableRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>, future: UnsafeMutablePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafeMutablePointer<Pointee> {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&ptr, .acquire).assumingMemoryBound(to: Pointee.self)
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutablePointer<Pointee>
  {
    return CAtomicsLoad(&ptr, order).assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>, order: MemoryOrder = .acqrel) -> UnsafeMutablePointer<Pointee>
  {
    return CAtomicsExchange(&ptr, pointer, order).assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutablePointer<Pointee>,
                               future: UnsafeMutablePointer<Pointee>,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeMutableRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>, future: UnsafeMutablePointer<Pointee>,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
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
    CAtomicsInitialize(&ptr, pointer)
  }

  public mutating func initialize(_ pointer: UnsafePointer<Pointee>?)
  {
    CAtomicsInitialize(&ptr, pointer)
  }

#if swift(>=4.2)
  public var pointer: UnsafePointer<Pointee>? {
    @inlinable
    mutating get {
      return CAtomicsLoad(&ptr, .acquire)?.assumingMemoryBound(to: Pointee.self)
    }
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafePointer<Pointee>?
  {
    return CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .acqrel) -> UnsafePointer<Pointee>?
  {
    return CAtomicsExchange(&ptr, pointer, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafePointer<Pointee>?,
                               future: UnsafePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c?.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&ptr, .acquire)?.assumingMemoryBound(to: Pointee.self)
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafePointer<Pointee>?
  {
    return CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .acqrel) -> UnsafePointer<Pointee>?
  {
    return CAtomicsExchange(&ptr, pointer, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafePointer<Pointee>?,
                               future: UnsafePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c?.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
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
    CAtomicsInitialize(&ptr, pointer)
  }

  public mutating func initialize(_ pointer: UnsafeMutablePointer<Pointee>?)
  {
    CAtomicsInitialize(&ptr, pointer)
  }

#if swift(>=4.2)
  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inlinable
    mutating get {
      return CAtomicsLoad(&ptr, .acquire)?.assumingMemoryBound(to: Pointee.self)
    }
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutablePointer<Pointee>?
  {
    return CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .acqrel) -> UnsafeMutablePointer<Pointee>?
  {
    return CAtomicsExchange(&ptr, pointer, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutablePointer<Pointee>?,
                               future: UnsafeMutablePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeMutableRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c?.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&ptr, .acquire)?.assumingMemoryBound(to: Pointee.self)
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutablePointer<Pointee>?
  {
    return CAtomicsLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&ptr, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .acqrel) -> UnsafeMutablePointer<Pointee>?
  {
    return CAtomicsExchange(&ptr, pointer, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutablePointer<Pointee>?,
                               future: UnsafeMutablePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = UnsafeMutableRawPointer(current)
    let s = (type == .weak)
            ? CAtomicsCompareAndExchangeWeak(&ptr, &c, future, orderSwap, orderLoad)
            : CAtomicsCompareAndExchangeStrong(&ptr, &c, future, orderSwap, orderLoad)
    current = c?.assumingMemoryBound(to: Pointee.self)
    return s
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#endif
}

@_exported import struct CAtomics.AtomicRawPointer

extension AtomicRawPointer
{
#if swift(>=4.2)
  public var pointer: UnsafeRawPointer {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inlinable
  public mutating func initialize(_ pointer: UnsafeRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeRawPointer
  {
    return CAtomicsLoad(&self, order)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafeRawPointer, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafeRawPointer, order: MemoryOrder = .acqrel) -> UnsafeRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafeRawPointer,
                               future: UnsafeRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeRawPointer, future: UnsafeRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafeRawPointer {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeRawPointer
  {
    return CAtomicsLoad(&self, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer, order: MemoryOrder = .acqrel) -> UnsafeRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafeRawPointer,
                               future: UnsafeRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeRawPointer, future: UnsafeRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
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
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inlinable
  public mutating func initialize(_ pointer: UnsafeRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .acqrel) -> UnsafeRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafeRawPointer?,
                               future: UnsafeRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .acqrel) -> UnsafeRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafeRawPointer?,
                               future: UnsafeRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#endif
}

@_exported import struct CAtomics.AtomicMutableRawPointer

extension AtomicMutableRawPointer
{
#if swift(>=4.2)
  public var pointer: UnsafeMutableRawPointer {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inlinable
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutableRawPointer
  {
    return CAtomicsLoad(&self, order)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafeMutableRawPointer, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafeMutableRawPointer, order: MemoryOrder = .acqrel) -> UnsafeMutableRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutableRawPointer,
                               future: UnsafeMutableRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer, future: UnsafeMutableRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafeMutableRawPointer {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutableRawPointer
  {
    return CAtomicsLoad(&self, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer, order: MemoryOrder = .acqrel) -> UnsafeMutableRawPointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutableRawPointer,
                               future: UnsafeMutableRawPointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer, future: UnsafeMutableRawPointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
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
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inlinable
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutableRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }

  @inlinable
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .acqrel) -> UnsafeMutableRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutableRawPointer?,
                               future: UnsafeMutableRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inlinable @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inline(__always)
  public mutating func initialize(_ pointer: UnsafeMutableRawPointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> UnsafeMutableRawPointer?
  {
    return CAtomicsLoad(&self, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .acqrel) -> UnsafeMutableRawPointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout UnsafeMutableRawPointer?,
                               future: UnsafeMutableRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#endif
}

@_exported import struct CAtomics.AtomicOpaquePointer

extension AtomicOpaquePointer
{
#if swift(>=4.2)
  public var pointer: OpaquePointer {
    @inlinable
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inlinable
  public mutating func initialize(_ pointer: OpaquePointer)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> OpaquePointer
  {
    return CAtomicsLoad(&self, order)
  }

  @inlinable
  public mutating func store(_ pointer: OpaquePointer, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: OpaquePointer, order: MemoryOrder = .acqrel) -> OpaquePointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout OpaquePointer,
                               future: OpaquePointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inlinable @discardableResult
  public mutating func CAS(current: OpaquePointer, future: OpaquePointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: OpaquePointer {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inline(__always)
  public mutating func initialize(_ pointer: OpaquePointer)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> OpaquePointer
  {
    return CAtomicsLoad(&self, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer, order: MemoryOrder = .acqrel) -> OpaquePointer
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout OpaquePointer,
                               future: OpaquePointer,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer, future: OpaquePointer,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
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
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inlinable
  public mutating func initialize(_ pointer: OpaquePointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> OpaquePointer?
  {
    return CAtomicsLoad(&self, order)
  }

  @inlinable
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inlinable
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .acqrel) -> OpaquePointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inlinable @discardableResult
  public mutating func loadCAS(current: inout OpaquePointer?,
                               future: OpaquePointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inlinable @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#else
  public var pointer: OpaquePointer? {
    @inline(__always)
    mutating get {
      return CAtomicsLoad(&self, .acquire)
    }
  }

  @inline(__always)
  public mutating func initialize(_ pointer: OpaquePointer?)
  {
    CAtomicsInitialize(&self, pointer)
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> OpaquePointer?
  {
    return CAtomicsLoad(&self, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, pointer, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .acqrel) -> OpaquePointer?
  {
    return CAtomicsExchange(&self, pointer, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout OpaquePointer?,
                               future: OpaquePointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    return type == .weak
    ? CAtomicsCompareAndExchangeWeak(&self, &current, future, orderSwap, orderLoad)
    : CAtomicsCompareAndExchangeStrong(&self, &current, future, orderSwap, orderLoad)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    var current = current
    return loadCAS(current: &current, future: future, type: type,
                   orderSwap: order, orderLoad: order.asLoadOrdering())
  }
#endif
}

@_exported import struct CAtomics.AtomicTaggedRawPointer

extension AtomicTaggedRawPointer
{
  public init(_ p: (pointer: UnsafeRawPointer, tag: Int))
  {
    self.init(TaggedRawPointer(p.pointer, tag: p.tag))
  }

#if swift(>=4.2)
  public var value: (pointer: UnsafeRawPointer, tag: Int) {
    @inlinable
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#else
  public var value: (pointer: UnsafeRawPointer, tag: Int) {
    @inline(__always)
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ p: (pointer: UnsafeRawPointer, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedRawPointer(p.pointer, tag: p.tag))
  }
#else
  @inline(__always)
  public mutating func initialize(_ p: (pointer: UnsafeRawPointer, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedRawPointer(p.pointer, tag: p.tag))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeRawPointer, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeRawPointer, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ p: (pointer: UnsafeRawPointer, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedRawPointer(p.pointer, tag: p.tag), order)
  }
#else
  @inline(__always)
  public mutating func store(_ p: (pointer: UnsafeRawPointer, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedRawPointer(p.pointer, tag: p.tag), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ p: (pointer: UnsafeRawPointer, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeRawPointer, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func swap(_ p: (pointer: UnsafeRawPointer, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeRawPointer, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeRawPointer, tag: Int),
                               future: (pointer: UnsafeRawPointer, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedRawPointer(current.0, tag: current.1)
    let f = TaggedRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeRawPointer, tag: Int),
                               future: (pointer: UnsafeRawPointer, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedRawPointer(current.0, tag: current.1)
    let f = TaggedRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: (pointer: UnsafeRawPointer, tag: Int),
                           future: (pointer: UnsafeRawPointer, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedRawPointer(current.0, tag: current.1)
    let f = TaggedRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: (pointer: UnsafeRawPointer, tag: Int),
                           future: (pointer: UnsafeRawPointer, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedRawPointer(current.0, tag: current.1)
    let f = TaggedRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicTaggedOptionalRawPointer

extension AtomicTaggedOptionalRawPointer
{
  public init(_ p: (pointer: UnsafeRawPointer?, tag: Int))
  {
    self.init(TaggedOptionalRawPointer(p.pointer, tag: p.tag))
  }

#if swift(>=4.2)
  public var value: (pointer: UnsafeRawPointer?, tag: Int) {
    @inlinable
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#else
  public var value: (pointer: UnsafeRawPointer?, tag: Int) {
    @inline(__always)
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ p: (pointer: UnsafeRawPointer?, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedOptionalRawPointer(p.pointer, tag: p.tag))
  }
#else
  @inline(__always)
  public mutating func initialize(_ p: (pointer: UnsafeRawPointer?, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedOptionalRawPointer(p.pointer, tag: p.tag))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeRawPointer?, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeRawPointer?, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ p: (pointer: UnsafeRawPointer?, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedOptionalRawPointer(p.pointer, tag: p.tag), order)
  }
#else
  @inline(__always)
  public mutating func store(_ p: (pointer: UnsafeRawPointer?, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedOptionalRawPointer(p.pointer, tag: p.tag), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ p: (pointer: UnsafeRawPointer?, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeRawPointer?, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedOptionalRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func swap(_ p: (pointer: UnsafeRawPointer?, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeRawPointer?, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedOptionalRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeRawPointer?, tag: Int),
                               future: (pointer: UnsafeRawPointer?, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedOptionalRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeRawPointer?, tag: Int),
                               future: (pointer: UnsafeRawPointer?, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedOptionalRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: (pointer: UnsafeRawPointer?, tag: Int),
                           future: (pointer: UnsafeRawPointer?, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedOptionalRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: (pointer: UnsafeRawPointer?, tag: Int),
                           future: (pointer: UnsafeRawPointer?, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedOptionalRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicTaggedMutableRawPointer

extension AtomicTaggedMutableRawPointer
{
  public init(_ p: (pointer: UnsafeMutableRawPointer, tag: Int))
  {
    self.init(TaggedMutableRawPointer(p.pointer, tag: p.tag))
  }

#if swift(>=4.2)
  public var value: (pointer: UnsafeMutableRawPointer, tag: Int) {
    @inlinable
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#else
  public var value: (pointer: UnsafeMutableRawPointer, tag: Int) {
    @inline(__always)
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ p: (pointer: UnsafeMutableRawPointer, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedMutableRawPointer(p.pointer, tag: p.tag))
  }
#else
  @inline(__always)
  public mutating func initialize(_ p: (pointer: UnsafeMutableRawPointer, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedMutableRawPointer(p.pointer, tag: p.tag))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeMutableRawPointer, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeMutableRawPointer, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ p: (pointer: UnsafeMutableRawPointer, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedMutableRawPointer(p.pointer, tag: p.tag), order)
  }
#else
  @inline(__always)
  public mutating func store(_ p: (pointer: UnsafeMutableRawPointer, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedMutableRawPointer(p.pointer, tag: p.tag), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ p: (pointer: UnsafeMutableRawPointer, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeMutableRawPointer, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedMutableRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func swap(_ p: (pointer: UnsafeMutableRawPointer, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeMutableRawPointer, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedMutableRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeMutableRawPointer, tag: Int),
                               future: (pointer: UnsafeMutableRawPointer, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedMutableRawPointer(current.0, tag: current.1)
    let f = TaggedMutableRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeMutableRawPointer, tag: Int),
                               future: (pointer: UnsafeMutableRawPointer, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedMutableRawPointer(current.0, tag: current.1)
    let f = TaggedMutableRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: (pointer: UnsafeMutableRawPointer, tag: Int),
                           future: (pointer: UnsafeMutableRawPointer, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedMutableRawPointer(current.0, tag: current.1)
    let f = TaggedMutableRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: (pointer: UnsafeMutableRawPointer, tag: Int),
                           future: (pointer: UnsafeMutableRawPointer, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedMutableRawPointer(current.0, tag: current.1)
    let f = TaggedMutableRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#endif
}

@_exported import struct CAtomics.AtomicTaggedOptionalMutableRawPointer

extension AtomicTaggedOptionalMutableRawPointer
{
  public init(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int))
  {
    self.init(TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag))
  }

#if swift(>=4.2)
  public var value: (pointer: UnsafeMutableRawPointer?, tag: Int) {
    @inlinable
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#else
  public var value: (pointer: UnsafeMutableRawPointer?, tag: Int) {
    @inline(__always)
    mutating get {
      let t = CAtomicsLoad(&self, .acquire)
      return (t.ptr, t.tag)
    }
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func initialize(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag))
  }
#else
  @inline(__always)
  public mutating func initialize(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int))
  {
    CAtomicsInitialize(&self, TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag))
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeMutableRawPointer?, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .acquire) -> (pointer: UnsafeMutableRawPointer?, tag: Int)
  {
    let t = CAtomicsLoad(&self, order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func store(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag), order)
  }
#else
  @inline(__always)
  public mutating func store(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int), order: StoreMemoryOrder = .release)
  {
    CAtomicsStore(&self, TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag), order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeMutableRawPointer?, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#else
  @inline(__always)
  public mutating func swap(_ p: (pointer: UnsafeMutableRawPointer?, tag: Int), order: MemoryOrder = .acqrel) -> (pointer: UnsafeMutableRawPointer?, tag: Int)
  {
    let t = CAtomicsExchange(&self, TaggedOptionalMutableRawPointer(p.pointer, tag: p.tag), order)
    return (t.ptr, t.tag)
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeMutableRawPointer?, tag: Int),
                               future: (pointer: UnsafeMutableRawPointer?, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedOptionalMutableRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalMutableRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#else
  @inline(__always) @discardableResult
  public mutating func loadCAS(current: inout (pointer: UnsafeMutableRawPointer?, tag: Int),
                               future: (pointer: UnsafeMutableRawPointer?, tag: Int),
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .acqrel,
                               orderLoad: LoadMemoryOrder = .acquire) -> Bool
  {
    var c = TaggedOptionalMutableRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalMutableRawPointer(future.0, tag: future.1)
    let s = CAtomicsCompareAndExchange(&self, &c, f, type, orderSwap, orderLoad)
    current = (c.ptr, c.tag)
    return s
  }
#endif

#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: (pointer: UnsafeMutableRawPointer?, tag: Int),
                           future: (pointer: UnsafeMutableRawPointer?, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedOptionalMutableRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalMutableRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: (pointer: UnsafeMutableRawPointer?, tag: Int),
                           future: (pointer: UnsafeMutableRawPointer?, tag: Int),
                           type: CASType = .strong,
                           order: MemoryOrder = .acqrel) -> Bool
  {
    let c = TaggedOptionalMutableRawPointer(current.0, tag: current.1)
    let f = TaggedOptionalMutableRawPointer(future.0, tag: future.1)
    return CAtomicsCompareAndExchange(&self, c, f, type, order)
  }
#endif
}

@available(*, unavailable, renamed: "AtomicPointer")
public typealias AtomicNonNullPointer<T> = AtomicPointer<T>

@available(*, unavailable, renamed: "AtomicMutablePointer")
public typealias AtomicNonNullMutablePointer<T> = AtomicMutablePointer<T>

@available(*, unavailable, renamed: "AtomicRawPointer")
public typealias AtomicNonNullRawPointer = AtomicRawPointer

@available(*, unavailable, renamed: "AtomicMutableRawPointer")
public typealias AtomicNonNullMutableRawPointer = AtomicMutableRawPointer

@available(*, unavailable, renamed: "AtomicOpaquePointer")
public typealias AtomicNonNullOpaquePointer = AtomicOpaquePointer
