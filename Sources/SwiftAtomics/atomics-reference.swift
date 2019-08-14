//
//  atomics-reference.swift
//  Atomics
//
//  Created by Guillaume Lessard on 1/16/17.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

@_exported import enum CAtomics.MemoryOrder
@_exported import enum CAtomics.LoadMemoryOrder
@_exported import enum CAtomics.StoreMemoryOrder
import CAtomics

import struct CAtomics.OpaqueUnmanagedHelper

#if !swift(>=3.2)
extension MemoryOrder
{
  @_versioned init(order: LoadMemoryOrder)
  {
    self = MemoryOrder.init(rawValue: order.rawValue) ?? .sequential
  }

  @_versioned init(order: StoreMemoryOrder)
  {
    self = MemoryOrder.init(rawValue: order.rawValue) ?? .sequential
  }
}
#endif

public struct AtomicReference<T: AnyObject>
{
#if swift(>=4.2)
  @usableFromInline internal var ptr = OpaqueUnmanagedHelper()
#else
  @_versioned internal var ptr = OpaqueUnmanagedHelper()
#endif

  public init(_ reference: T? = nil)
  {
    self.initialize(reference)
  }

  mutating public func initialize(_ reference: T?)
  {
    let u = reference.map { Unmanaged.passRetained($0).toOpaque() }
    CAtomicsInitialize(&ptr, u)
  }
}

extension AtomicReference
{
#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ reference: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = reference.map { Unmanaged.passRetained($0).toOpaque() }

    let pointer = CAtomicsExchange(&ptr, u, order)
    return pointer.map { Unmanaged.fromOpaque($0).takeRetainedValue() }
  }
#else
  @inline(__always)
  public mutating func swap(_ reference: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = reference.map { Unmanaged.passRetained($0).toOpaque() }

    let pointer = CAtomicsExchange(&ptr, u, order)
    return pointer.map { Unmanaged.fromOpaque($0).takeRetainedValue() }
  }
#endif

#if swift(>=5.0)
  @available(swift, obsoleted: 5.0, renamed: "storeIfNil(_:order:)")
  public mutating func swapIfNil(_ ref: T, order: MemoryOrder = .sequential) -> Bool { fatalError() }
#else
  @available(*, deprecated, renamed: "storeIfNil(_:order:)")
  public mutating func swapIfNil(_ ref: T, order: StoreMemoryOrder = .sequential) -> Bool
  {
    return self.storeIfNil(ref, order: order)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func storeIfNil(_ reference: T, order: StoreMemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(reference)
    if CAtomicsCompareAndExchange(&ptr, nil, u.toOpaque(), .strong, MemoryOrder(rawValue: order.rawValue)!)
    {
      _ = u.retain()
      return true
    }
    return false
  }
#elseif swift(>=3.2)
  @inline(__always)
  public mutating func storeIfNil(_ reference: T, order: StoreMemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(reference)
    if CAtomicsCompareAndExchange(&ptr, nil, u.toOpaque(), .strong, MemoryOrder(rawValue: order.rawValue)!)
    {
      _ = u.retain()
      return true
    }
    return false
  }
#else
  @inline(__always)
  public mutating func storeIfNil(_ reference: T, order: StoreMemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(reference)
    if CAtomicsCompareAndExchange(&ptr, nil, u.toOpaque(), .strong, MemoryOrder(order: order))
    {
      _ = u.retain()
      return true
    }
    return false
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func take(order: LoadMemoryOrder = .sequential) -> T?
  {
    let pointer = CAtomicsExchange(&ptr, nil, MemoryOrder(rawValue: order.rawValue)!)
    return pointer.map { Unmanaged.fromOpaque($0).takeRetainedValue() }
  }
#elseif swift(>=3.2)
  @inline(__always)
  public mutating func take(order: LoadMemoryOrder = .sequential) -> T?
  {
    let pointer = CAtomicsExchange(&ptr, nil, MemoryOrder(rawValue: order.rawValue)!)
    return pointer.map { Unmanaged.fromOpaque($0).takeRetainedValue() }
  }
#else // swift 3.1
  @inline(__always)
  public mutating func take(order: LoadMemoryOrder = .sequential) -> T?
  {
    let pointer = CAtomicsExchange(&ptr, nil, MemoryOrder(order: order))
    return pointer.map { Unmanaged.fromOpaque($0).takeRetainedValue() }
  }
#endif

#if swift(>=4.2)
  /// load the reference currently stored in this AtomicReference
  ///
  /// This is *not* an atomic operation if the reference is non-nil.
  /// In order to ensure the integrity of the automatic reference
  /// counting, the AtomicReference gets locked (internally) until the
  /// reference count has been incremented. The critical section
  /// protected by the lock is extremely short (nanoseconds), but necessary.
  ///
  /// This is the only AtomicReference operation that needs a lock;
  /// the others operations will spin until a `load` operation is complete,
  /// but are otherwise atomic.
  @inlinable
  public mutating func load() -> T?
  {
    if let pointer = CAtomicsUnmanagedLockAndLoad(&ptr, .acquire)
    {
      assert(CAtomicsLoad(&ptr, .sequential) == UnsafeRawPointer(bitPattern: 0x7))
      CAtomicsThreadFence(.acquire)
      let unmanaged = Unmanaged<T>.fromOpaque(pointer).retain()
      // ensure the reference counting operation has occurred before unlocking,
      // by performing our store operation with StoreMemoryOrder.release
      CAtomicsThreadFence(.release)
      CAtomicsStore(&ptr, pointer, .release)
      return unmanaged.takeRetainedValue()
    }
    return nil
  }
#else
  /// load the reference currently stored in this AtomicReference
  ///
  /// This is *not* an atomic operation if the reference is non-nil.
  /// In order to ensure the integrity of the automatic reference
  /// counting, the AtomicReference gets locked (internally) until the
  /// reference count has been incremented. The critical section
  /// protected by the lock is extremely short (nanoseconds), but necessary.
  ///
  /// This is the only AtomicReference operation that needs a lock;
  /// the others operations will spin until a `load` operation is complete,
  /// but are otherwise atomic.
  @inline(__always)
  public mutating func load() -> T?
  {
    if let pointer = CAtomicsUnmanagedLockAndLoad(&ptr, .acquire)
    {
      assert(CAtomicsLoad(&ptr, .sequential) == UnsafeRawPointer(bitPattern: 0x7))
      CAtomicsThreadFence(.acquire)
      let unmanaged = Unmanaged<T>.fromOpaque(pointer).retain()
      // ensure the reference counting operation has occurred before unlocking,
      // by performing our store operation with StoreMemoryOrder.release
      CAtomicsThreadFence(.release)
      CAtomicsStore(&ptr, pointer, .release)
      return unmanaged.takeRetainedValue()
    }
    return nil
  }
#endif
    
#if swift(>=4.2)
  @inlinable @discardableResult
  public mutating func CAS(current: T?, future: T?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    let c = current.map(Unmanaged.passUnretained)
    let f = future.map(Unmanaged.passUnretained)

    guard CAtomicsCompareAndExchange(&ptr, c?.toOpaque(), f?.toOpaque(), type, order)
      else { return false }
    _ = f?.retain()
    c?.release()
    return true
  }
#else
  @inline(__always) @discardableResult
  public mutating func CAS(current: T?, future: T?,
                           type: CASType = .strong,
                           order: MemoryOrder = .sequential) -> Bool
  {
    let c = current.map(Unmanaged.passUnretained)
    let f = future.map(Unmanaged.passUnretained)

    guard CAtomicsCompareAndExchange(&ptr, c?.toOpaque(), f?.toOpaque(), type, order)
      else { return false }
    _ = f?.retain()
    c?.release()
    return true
  }
#endif
}
