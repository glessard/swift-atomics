//
//  atomics-pointer.swift
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015, 2016 Guillaume Lessard. All rights reserved.
//

import CAtomics

public struct AtomicMutableRawPointer
{
  @_versioned var ptr = CAtomicsMutablePointer()

  public init(_ pointer: UnsafeMutableRawPointer? = nil)
  {
    CAtomicsMutablePointerInit(UnsafeMutableRawPointer(pointer), &ptr)
  }

  public var pointer: UnsafeMutableRawPointer? {
    @inline(__always)
    mutating get {
      return UnsafeMutableRawPointer(CAtomicsMutablePointerLoad(&ptr, .relaxed))
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return UnsafeMutableRawPointer(CAtomicsMutablePointerLoad(&ptr, order))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutableRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsMutablePointerStore(UnsafeMutableRawPointer(pointer), &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutableRawPointer?, order: MemoryOrder = .sequential) -> UnsafeMutableRawPointer?
  {
    return UnsafeMutableRawPointer(CAtomicsMutablePointerSwap(UnsafeMutableRawPointer(pointer), &ptr, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                               future: UnsafeMutableRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeMutableRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAtomicsMutablePointerStrongCAS(current, UnsafeMutableRawPointer(future), &ptr, orderSwap, orderLoad)
      case .weak:
        return CAtomicsMutablePointerWeakCAS(current, UnsafeMutableRawPointer(future), &ptr, orderSwap, orderLoad)
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
  @_versioned var ptr = CAtomicsPointer()

  public init(_ pointer: UnsafeRawPointer? = nil)
  {
    CAtomicsPointerInit(UnsafeRawPointer(pointer), &ptr)
  }

  public var pointer: UnsafeRawPointer? {
    @inline(__always)
    mutating get {
      return UnsafeRawPointer(CAtomicsPointerLoad(&ptr, .relaxed))
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(CAtomicsPointerLoad(&ptr, order))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeRawPointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsPointerStore(UnsafeRawPointer(pointer), &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeRawPointer?, order: MemoryOrder = .sequential) -> UnsafeRawPointer?
  {
    return UnsafeRawPointer(CAtomicsPointerSwap(UnsafeRawPointer(pointer), &ptr, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeRawPointer?>,
                               future: UnsafeRawPointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAtomicsPointerStrongCAS(current, UnsafeRawPointer(future), &ptr, orderSwap, orderLoad)
      case .weak:
        return CAtomicsPointerWeakCAS(current, UnsafeRawPointer(future), &ptr, orderSwap, orderLoad)
      }
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
  @_versioned var ptr = CAtomicsMutablePointer()

  public init(_ pointer: UnsafeMutablePointer<Pointee>? = nil)
  {
    CAtomicsMutablePointerInit(UnsafeMutableRawPointer(pointer), &ptr)
  }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return UnsafeMutablePointer<Pointee>(CAtomicsMutablePointerLoad(&ptr, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsMutablePointerLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsMutablePointerStore(UnsafeMutableRawPointer(pointer), &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer<Pointee>(CAtomicsMutablePointerSwap(UnsafeMutableRawPointer(pointer), &ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafeMutablePointer<Pointee>?>,
                               future: UnsafeMutablePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeMutableRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAtomicsMutablePointerStrongCAS(current, UnsafeMutableRawPointer(future), &ptr, orderSwap, orderLoad)
      case .weak:
        return CAtomicsMutablePointerWeakCAS(current, UnsafeMutableRawPointer(future), &ptr, orderSwap, orderLoad)
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
  @_versioned var ptr = CAtomicsPointer()

  public init(_ pointer: UnsafePointer<Pointee>? = nil)
  {
    CAtomicsPointerInit(UnsafeRawPointer(pointer), &ptr)
  }

  public var pointer: UnsafePointer<Pointee>? {
    @inline(__always)
    mutating get {
      return UnsafePointer<Pointee>(CAtomicsPointerLoad(&ptr, .relaxed)?.assumingMemoryBound(to: Pointee.self))
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsPointerLoad(&ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsPointerStore(UnsafeRawPointer(pointer), &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .sequential) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer<Pointee>(CAtomicsPointerSwap(UnsafeRawPointer(pointer), &ptr, order)?.assumingMemoryBound(to: Pointee.self))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<UnsafePointer<Pointee>?>,
                               future: UnsafePointer<Pointee>?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAtomicsPointerStrongCAS(current, UnsafeRawPointer(future), &ptr, orderSwap, orderLoad)
      case .weak:
        return CAtomicsPointerWeakCAS(current, UnsafeRawPointer(future), &ptr, orderSwap, orderLoad)
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
  @_versioned var ptr = CAtomicsPointer()

  public init(_ pointer: OpaquePointer? = nil)
  {
    CAtomicsPointerInit(UnsafeRawPointer(pointer), &ptr)
  }

  public var pointer: OpaquePointer? {
    @inline(__always)
    mutating get {
      return OpaquePointer(CAtomicsPointerLoad(&ptr, .relaxed))
    }
  }

  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(CAtomicsPointerLoad(&ptr, order))
  }

  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .sequential)
  {
    CAtomicsPointerStore(UnsafeRawPointer(pointer), &ptr, order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .sequential) -> OpaquePointer?
  {
    return OpaquePointer(CAtomicsPointerSwap(UnsafeRawPointer(pointer), &ptr, order))
  }

  @inline(__always) @discardableResult
  public mutating func loadCAS(current: UnsafeMutablePointer<OpaquePointer?>,
                               future: OpaquePointer?,
                               type: CASType = .weak,
                               orderSwap: MemoryOrder = .sequential,
                               orderLoad: LoadMemoryOrder = .sequential) -> Bool
  {
    return current.withMemoryRebound(to: Optional<UnsafeRawPointer>.self, capacity: 1) {
      current in
      switch type {
      case .strong:
        return CAtomicsPointerStrongCAS(current, UnsafeRawPointer(future), &ptr, orderSwap, orderLoad)
      case .weak:
        return CAtomicsPointerWeakCAS(current, UnsafeRawPointer(future), &ptr, orderSwap, orderLoad)
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
