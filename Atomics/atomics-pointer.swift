//
//  atomics-pointer.swift
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015, 2016 Guillaume Lessard. All rights reserved.
//

import clang_atomics

// MARK: Pointer Atomics

public struct AtomicMutablePointer<Pointee>: NilLiteralConvertible
{
  private var ptr: UnsafeMutablePointer<Void>?
  public init(_ ptr: UnsafeMutablePointer<Pointee>? = nil) { self.ptr = UnsafeMutablePointer(ptr) }
  public init(nilLiteral: ()) { self.ptr = nil }

  public var pointer: UnsafeMutablePointer<Pointee>? {
    mutating get { return UnsafeMutablePointer(ReadVoidPtr(&ptr, memory_order_relaxed)) }
  }
}

extension AtomicMutablePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer(ReadVoidPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafeMutablePointer<Pointee>?, order: StoreMemoryOrder = .relaxed)
  {
    StoreVoidPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafeMutablePointer<Pointee>?, order: MemoryOrder = .relaxed) -> UnsafeMutablePointer<Pointee>?
  {
    return UnsafeMutablePointer(SwapVoidPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafeMutablePointer<Pointee>?, future: UnsafeMutablePointer<Pointee>?,
                           type: CASType = .strong,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    var expect = UnsafeMutablePointer<Void>(current)
    switch type {
    case .strong:
      return CASVoidPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeakVoidPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicPointer<Pointee>: NilLiteralConvertible
{
  private var ptr: UnsafeMutablePointer<Void>?
  public init(_ ptr: UnsafePointer<Pointee>? = nil) { self.ptr = UnsafeMutablePointer(ptr) }
  public init(nilLiteral: ()) { self.ptr = nil }

  public var pointer: UnsafePointer<Pointee> {
    mutating get { return UnsafePointer(ReadVoidPtr(&ptr, memory_order_relaxed)) }
  }
}

extension AtomicPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(ReadVoidPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(_ pointer: UnsafePointer<Pointee>?, order: StoreMemoryOrder = .relaxed)
  {
    StoreVoidPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: UnsafePointer<Pointee>?, order: MemoryOrder = .relaxed) -> UnsafePointer<Pointee>?
  {
    return UnsafePointer(SwapVoidPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: UnsafePointer<Pointee>?, future: UnsafePointer<Pointee>?,
                           type: CASType = .strong,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    var expect = UnsafeMutablePointer<Void>(current)
    switch type {
    case .strong:
      return CASVoidPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeakVoidPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}

public struct AtomicOpaquePointer: NilLiteralConvertible
{
  private var ptr: UnsafeMutablePointer<Void>?
  public init(_ ptr: OpaquePointer? = nil) { self.ptr = UnsafeMutablePointer(ptr) }
  public init(nilLiteral: ()) { self.ptr = nil }

  public var pointer: OpaquePointer? {
    mutating get { return OpaquePointer(ReadVoidPtr(&ptr, memory_order_relaxed)) }
  }
}

extension AtomicOpaquePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> OpaquePointer?
  {
    return OpaquePointer(ReadVoidPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(_ pointer: OpaquePointer?, order: StoreMemoryOrder = .relaxed)
  {
    StoreVoidPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(_ pointer: OpaquePointer?, order: MemoryOrder = .relaxed) -> OpaquePointer?
  {
    return OpaquePointer(SwapVoidPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always) @discardableResult
  public mutating func CAS(current: OpaquePointer?, future: OpaquePointer?,
                           type: CASType = .strong,
                           orderSuccess: MemoryOrder = .relaxed,
                           orderFailure: LoadMemoryOrder = .relaxed) -> Bool
  {
    var expect = UnsafeMutablePointer<Void>(current)
    switch type {
    case .strong:
      return CASVoidPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    case .weak:
      return CASWeakVoidPtr(&expect, UnsafePointer(future), &ptr, orderSuccess.order, orderFailure.order)
    }
  }
}
