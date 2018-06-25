//
//  atomics-reference.swift
//  Atomics
//
//  Created by Guillaume Lessard on 1/16/17.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//

@_exported import enum CAtomics.MemoryOrder

public struct AtomicReference<T: AnyObject>
{
#if swift(>=4.2)
  @usableFromInline internal var ptr = AtomicMutableRawPointer()
#else
  @_versioned internal var ptr = AtomicMutableRawPointer()
#endif

  public init(_ ref: T? = nil)
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    ptr.initialize(u)
  }
}

extension AtomicReference
{
#if swift(>=4.2)
  @inlinable
  public mutating func swap(_ ref: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    if let pointer = ptr.swap(u, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }
#else
  @inline(__always)
  public mutating func swap(_ ref: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    if let pointer = ptr.swap(u, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func swapIfNil(_ ref: T, order: MemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(ref)
    if ptr.CAS(nil, u.toOpaque(), .strong, order)
    {
      _ = u.retain()
      return true
    }
    return false
  }
#else
  @inline(__always)
  public mutating func swapIfNil(_ ref: T, order: MemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(ref)
    if ptr.CAS(nil, u.toOpaque(), .strong, order)
    {
      _ = u.retain()
      return true
    }
    return false
  }
#endif

#if swift(>=4.2)
  @inlinable
  public mutating func take(order: MemoryOrder = .sequential) -> T?
  {
    if let pointer = ptr.swap(nil, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }
#else
  @inline(__always)
  public mutating func take(order: MemoryOrder = .sequential) -> T?
  {
    if let pointer = ptr.swap(nil, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }
#endif
}

extension Unmanaged
{
#if swift(>=4.2)
  @usableFromInline static func tryRetain(_ optional: Instance?) -> Unmanaged<Instance>?
  {
    guard let reference = optional else { return nil }
    return Unmanaged.passRetained(reference)
  }
#else
  @_versioned static func tryRetain(_ optional: Instance?) -> Unmanaged<Instance>?
  {
    guard let reference = optional else { return nil }
    return Unmanaged.passRetained(reference)
  }
#endif
}
