//
//  atomics-reference.swift
//  Atomics
//
//  Created by Guillaume Lessard on 1/16/17.
//  Copyright © 2017 Guillaume Lessard. All rights reserved.
//

import ClangAtomics

public struct AtomicReference<T: AnyObject>
{
  @_versioned internal var ptr = AtomicVoidPointer()

  public init(_ ref: T? = nil)
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    AtomicPointerInit(u, &ptr)
  }
}

extension AtomicReference
{
  @inline(__always)
  public mutating func swap(_ ref: T?, order: MemoryOrder = .sequential) -> T?
  {
    let u = Unmanaged.tryRetain(ref)?.toOpaque()
    if let pointer = AtomicPointerSwap(u, &ptr, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }

  @inline(__always)
  public mutating func swapIfNil(_ ref: T, order: MemoryOrder = .sequential) -> Bool
  {
    let u = Unmanaged.passUnretained(ref)
    var null: UnsafeRawPointer? = nil
    if AtomicPointerStrongCAS(&null, u.toOpaque(), &ptr, order, .relaxed)
    {
      _ = u.retain()
      return true
    }
    return false
  }

  @inline(__always)
  public mutating func take(order: MemoryOrder = .sequential) -> T?
  {
    if let pointer = AtomicPointerSwap(nil, &ptr, order)
    {
      return Unmanaged<T>.fromOpaque(pointer).takeRetainedValue()
    }
    return nil
  }
}

extension Unmanaged
{
  @_versioned static func tryRetain(_ optional: Instance?) -> Unmanaged<Instance>?
  {
    guard let reference = optional else { return nil }
    return Unmanaged.passRetained(reference)
  }
}
