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
  @_versioned internal var ptr = AtomicVoidPointer()
  public init(_ pointer: UnsafeMutableRawPointer? = nil)
  {
    AtomicPointerInit(pointer, &ptr)
  }

  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    mutating get {
      return AtomicPointerLoad(&ptr, .relaxed)
    }
  }
}

extension AtomicMutableRawPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return AtomicPointerLoad(&ptr, order)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return AtomicPointerSwap(pointer, &ptr, order)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                               future: UnsafeMutableRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, future, &ptr, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, future, &ptr, orderSwap, orderLoad)
      }
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutableRawPointer?, future: UnsafeMutableRawPointer?,
                           type: CASType = .weak,
                           order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicRawPointer
{
  @_versioned internal var ptr = AtomicVoidPointer()
  public init(_ pointer: UnsafeRawPointer? = nil)
  {
    AtomicPointerInit(pointer, &ptr)
  }

  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    mutating get {
      return UnsafeRawPointer(AtomicPointerLoad(&ptr, LoadMemoryOrder.relaxed))
    }
  }
}

extension AtomicRawPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(AtomicPointerLoad(&ptr, order))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(AtomicPointerSwap(pointer, &ptr, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                               future: UnsafeRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    switch type {
    case .strong:
      return AtomicPointerStrongCAS(current, future, &ptr, orderSwap, orderLoad)
    case .weak:
      return AtomicPointerWeakCAS(current, future, &ptr, orderSwap, orderLoad)
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeRawPointer?, future: UnsafeRawPointer?,
                           type: CASType = .weak,
                           order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicMutablePointer<Pointee>
{
  @_versioned internal var ptr = AtomicVoidPointer()
  public init(_ pointer: UnsafeMutablePointer<Pointee>? = nil)
  {
    AtomicPointerInit(pointer, &ptr)
  }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return AtomicPointerLoad(&ptr, LoadMemoryOrder.relaxed)?.assumingMemoryBound(to: Pointee.self)
    }
  }
}

extension AtomicMutablePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return AtomicPointerLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return AtomicPointerSwap(pointer, &ptr, order)?.assumingMemoryBound(to: Pointee.self)
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                               future: UnsafeMutablePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, future, &ptr, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, future, &ptr, orderSwap, orderLoad)
      }
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .weak,
                           order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicPointer<Pointee>
{
  @_versioned internal var ptr = AtomicVoidPointer()
  public init(_ pointer: UnsafePointer<Pointee>? = nil)
  {
    AtomicPointerInit(pointer, &ptr)
  }

  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return UnsafePointer(AtomicPointerLoad(&ptr, LoadMemoryOrder.relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }
}

extension AtomicPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(AtomicPointerLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(pointer, &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(AtomicPointerSwap(pointer, &ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                               future: UnsafePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, future, &ptr, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, future, &ptr, orderSwap, orderLoad)
      }
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .weak,
                           order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}

public struct AtomicOpaquePointer
{
  @_versioned internal var ptr = AtomicVoidPointer()
  public init(_ pointer: OpaquePointer? = nil)
  {
    AtomicPointerInit(UnsafeRawPointer(pointer), &ptr)
  }

  public var pointer: OpaquePointer? {
    @inline(__always)
    mutating get {
      return OpaquePointer(AtomicPointerLoad(&ptr, LoadMemoryOrder.relaxed))
    }
  }
}

extension AtomicOpaquePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(AtomicPointerLoad(&ptr, order))
  }

  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    AtomicPointerStore(UnsafePointer(pointer), &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(AtomicPointerSwap(UnsafePointer(pointer), &ptr, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                               future: OpaquePointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    assert(orderLoad.rawValue <= orderSwap.rawValue)
    assert(orderSwap == .release ? orderLoad == .relaxed : true)
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return AtomicPointerStrongCAS(current, UnsafePointer(future), &ptr, orderSwap, orderLoad)
      case .weak:
        return AtomicPointerWeakCAS(current, UnsafePointer(future), &ptr, orderSwap, orderLoad)
      }
    }
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .weak,
                           order: MemoryOrder = .sequential) -> Bool
  {
    var expect = current
    return loadCAS(current: &expect, future: future, type: type, orderSwap: order, orderLoad: .relaxed)
  }
}
