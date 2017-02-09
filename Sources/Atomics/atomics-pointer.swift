//
//  atomics-pointer.swift
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015, 2016 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

// MARK: Pointer Atomics

public struct AtomicMutableRawPointer
{
  @_versioned internal var ptr = RawPointer()
  public init(_ pointer: UnsafeMutableRawPointer? = nil)
  {
    InitRawPtr(pointer, &ptr)
  }

  public var pointer: UnsafeMutableRawPointer? {
    mutating get {
      return ReadRawPtr(&ptr, memory_order_relaxed)
    }
  }
}

extension AtomicMutableRawPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return ReadRawPtr(&ptr, order.order)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return SwapRawPtr(pointer, &ptr, order.order)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                           type: CASType = .weak,
                           orderSuccess: MemoryOrder = .sequential,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = UnsafeMutableRawPointer(current)
    switch type {
    case .strong:
      return CASRawPtr(&expect, future, &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return WeakCASRawPtr(&expect, future, &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicRawPointer
{
  @_versioned internal var ptr = RawPointer()
  public init(_ pointer: UnsafeRawPointer? = nil)
  {
    InitRawPtr(pointer, &ptr)
  }

  public var pointer: UnsafeRawPointer? {
    mutating get {
      return UnsafeRawPointer(ReadRawPtr(&ptr, memory_order_relaxed))
    }
  }
}

extension AtomicRawPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(ReadRawPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(SwapRawPtr(pointer, &ptr, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                           type: CASType = .weak,
                           orderSuccess: MemoryOrder = .sequential,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = UnsafeMutableRawPointer(mutating: current)
    switch type {
    case .strong:
      return CASRawPtr(&expect, future, &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return WeakCASRawPtr(&expect, future, &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicMutablePointer<Pointee>
{
  @_versioned internal var ptr = RawPointer()
  public init(_ pointer: UnsafeMutablePointer<Pointee>? = nil)
  {
    InitRawPtr(pointer, &ptr)
  }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    mutating get {
      return ReadRawPtr(&ptr, memory_order_relaxed)?.assumingMemoryBound(to: Pointee.self)
    }
  }
}

extension AtomicMutablePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return ReadRawPtr(&ptr, order.order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return SwapRawPtr(UnsafePointer(pointer), &ptr, order.order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .weak,
                           orderSuccess: MemoryOrder = .sequential,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = UnsafeMutableRawPointer(current)
    switch type {
    case .strong:
      return CASRawPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return WeakCASRawPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicPointer<Pointee>
{
  @_versioned internal var ptr = RawPointer()
  public init(_ pointer: UnsafePointer<Pointee>? = nil)
  {
    InitRawPtr(pointer, &ptr)
  }

  public var pointer: UnsafePointer<Pointee>? {
    mutating get {
      return UnsafePointer(ReadRawPtr(&ptr, memory_order_relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }
}

extension AtomicPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(ReadRawPtr(&ptr, order.order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(pointer, &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(SwapRawPtr(UnsafePointer(pointer), &ptr, order.order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .weak,
                           orderSuccess: MemoryOrder = .sequential,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = UnsafeMutableRawPointer(mutating: current)
    switch type {
    case .strong:
      return CASRawPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return WeakCASRawPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicOpaquePointer
{
  @_versioned internal var ptr = RawPointer()
  public init(_ pointer: OpaquePointer? = nil)
  {
    InitRawPtr(UnsafeRawPointer(pointer), &ptr)
  }

  public var pointer: OpaquePointer? {
    mutating get { return OpaquePointer(ReadRawPtr(&ptr, memory_order_relaxed)) }
  }
}

extension AtomicOpaquePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(ReadRawPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    StoreRawPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(SwapRawPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .weak,
                           orderSuccess: MemoryOrder = .sequential,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    assert(orderFailure.rawValue <= orderSuccess.rawValue)
    var expect = UnsafeMutableRawPointer(current)
    switch type {
    case .strong:
      return CASRawPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return WeakCASRawPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}
