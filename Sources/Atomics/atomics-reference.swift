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

import struct CAtomics.OpaqueUnmanagedHelper

public struct AtomicReference<T: AnyObject>
{
#if swift(>=4.2)
    @usableFromInline internal var ptr = AtomicOptionalRawPointer()
#else
  @_versioned internal var ptr = AtomicOptionalRawPointer()
#endif

  public init(_ reference: T? = nil)
  {
    self.initialize(reference)
  }

  mutating public func initialize(_ reference: T?)
  {
    let u = reference.map { UnsafeRawPointer(Unmanaged.passRetained($0).toOpaque()) }
    ptr.initialize(u)
  }
}

extension AtomicReference
{
#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ reference: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = reference.map(Unmanaged.passRetained)?.toOpaque()

    let pointer = ptr.swap(u, order)
    return pointer.map(Unmanaged.fromOpaque)?.takeRetainedValue()
  }
#else
  @inline(__always)
  public mutating func swap(_ reference: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = reference.map(Unmanaged.passRetained)?.toOpaque()

    let pointer = ptr.swap(u, order)
    return pointer.map(Unmanaged.fromOpaque)?.takeRetainedValue()
  }
#endif

  @available(*, deprecated, renamed: "storeIfNil(_:order:)")
  public mutating func swapIfNil(_ ref: T, order: MemoryOrder = .sequential) -> Bool
  {
    let newOrder = StoreMemoryOrder(rawValue: order.rawValue) ?? .sequential
    return self.storeIfNil(ref, order: newOrder)
  }


#if swift(>=4.2)
  @inlinable
  public mutating func storeIfNil(_ reference: T, order: StoreMemoryOrder = .sequential) -> Bool
  {
    return CAS(current: nil, future: reference)
  }
#else
  @inline(__always)
  public mutating func storeIfNil(_ reference: T, order: StoreMemoryOrder = .sequential) -> Bool
  {
    return CAS(current: nil, future: reference)
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func take(order: LoadMemoryOrder = .sequential) -> T?
  {
    let pointer = ptr.swap(nil)
    return pointer.map(Unmanaged.fromOpaque)?.takeUnretainedValue()
  }
#else
  @inline(__always)
  public mutating func take(order: LoadMemoryOrder = .sequential) -> T?
  {
    let pointer = ptr.swap(nil)
    return pointer.map(Unmanaged.fromOpaque)?.takeUnretainedValue()
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
  public mutating func load(order: LoadMemoryOrder = .sequential) -> T?
  {
    if let pointer = ptr.load(order)
    {
//      assert(ptr.load(.sequential) == UnsafeRawPointer(bitPattern: 0x7))
      return Unmanaged.fromOpaque(pointer).takeUnretainedValue()
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
  public mutating func load(order: LoadMemoryOrder = .sequential) -> T?
  {
    if let pointer = ptr.load(order)
    {
    assert(ptr.load(.sequential) == UnsafeRawPointer(bitPattern: 0x7))
    return Unmanaged.fromOpaque(pointer).takeUnretainedValue()
    }
    return nil
  }
#endif
    
#if swift(>=4.2)
    @inlinable
    public mutating func CAS(current currentReference: T?, future futureReference: T?,
                             type: CASType = .strong,
                             order: MemoryOrder = .sequential) -> Bool
    {
        let current = currentReference.map { Unmanaged.passUnretained($0) }
        let future = futureReference.map { Unmanaged.passRetained($0) }
        let success = ptr.CAS(UnsafeRawPointer(current?.toOpaque()), UnsafeRawPointer(future?.toOpaque()), type, order)
        
        if success {
            current?.release()
        }
        else {
            future?.release()
        }
        
        return success
    }
#else
    @inline(__always) @discardableResult
    public mutating func CAS(current currentReference: T?, future futureReference: T?,
    type: CASType = .strong,
    order: MemoryOrder = .sequential) -> Bool
    {
        let current = currentReference.map { Unmanaged.passUnretained($0) }
        let future = futureReference.map { Unmanaged.passRetained($0) }
        let success = ptr.CAS(UnsafeRawPointer(current?.toOpaque()), UnsafeRawPointer(future?.toOpaque()), type, order)
        
        if success {
        current?.release()
        }
        else {
        future?.release()
        }
        
        return success
    }
#endif
}
