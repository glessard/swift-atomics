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

import struct CAtomics.RawUnmanaged

public struct AtomicReference<T: AnyObject>
{
#if swift(>=4.2)
  @usableFromInline internal var ptr = RawUnmanaged()
#else
  @_versioned internal var ptr = RawUnmanaged()
#endif

  public init(_ reference: T? = nil)
  {
    self.initialize(reference)
  }

  mutating public func initialize(_ reference: T?)
  {
    let u = reference.map(Unmanaged.passRetained)
    ptr.initialize(u?.toOpaque())
  }
}

extension AtomicReference
{
#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ reference: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = reference.map(Unmanaged.passRetained)?.toOpaque()

    let pointer = ptr.spinSwap(u, order)
    return pointer.map(Unmanaged.fromOpaque)?.takeRetainedValue()
  }
#else
  @inline(__always)
  public mutating func swap(_ reference: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = reference.map(Unmanaged.passRetained)?.toOpaque()

    let pointer = ptr.spinSwap(u, order)
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
    let u = Unmanaged.passUnretained(reference)
    if ptr.safeStore(u.toOpaque(), order)
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
    if ptr.safeStore(u.toOpaque(), order)
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
    let pointer = ptr.spinLoad(.null, order)
    return pointer.map(Unmanaged.fromOpaque)?.takeRetainedValue()
  }
#else
  @inline(__always)
  public mutating func take(order: LoadMemoryOrder = .sequential) -> T?
  {
    let pointer = ptr.spinLoad(.null, order)
    return pointer.map(Unmanaged.fromOpaque)?.takeRetainedValue()
  }
#endif
}
