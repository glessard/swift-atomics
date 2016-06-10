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
  private var ptr: UnsafeMutablePointer<Void>
  public init(_ ptr: UnsafeMutablePointer<Pointee> = nil) { self.ptr = UnsafeMutablePointer(ptr) }
  public init(nilLiteral: ()) { self.ptr = nil }

  public var pointer: UnsafeMutablePointer<Pointee> {
    mutating get { return UnsafeMutablePointer(ReadVoidPtr(&ptr, memory_order_relaxed)) }
    mutating set { StoreVoidPtr(newValue, &ptr, memory_order_relaxed) }
  }
}

extension AtomicMutablePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UnsafeMutablePointer<Pointee>
  {
    return UnsafeMutablePointer(ReadVoidPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(pointer: UnsafeMutablePointer<Pointee>, order: StoreMemoryOrder = .relaxed)
  {
    StoreVoidPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(pointer: UnsafeMutablePointer<Pointee>, order: MemoryOrder = .relaxed) -> UnsafeMutablePointer<Pointee>
  {
    return UnsafeMutablePointer(SwapVoidPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always)
  public mutating func CAS(current current: UnsafeMutablePointer<Pointee>, future: UnsafeMutablePointer<Pointee>,
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
  private var ptr: UnsafeMutablePointer<Void>
  public init(_ ptr: UnsafePointer<Pointee> = nil) { self.ptr = UnsafeMutablePointer(ptr) }
  public init(nilLiteral: ()) { self.ptr = nil }

  public var pointer: UnsafePointer<Pointee> {
    mutating get { return UnsafePointer(ReadVoidPtr(&ptr, memory_order_relaxed)) }
    mutating set { StoreVoidPtr(newValue, &ptr, memory_order_relaxed) }
  }
}

extension AtomicPointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> UnsafePointer<Pointee>
  {
    return UnsafePointer(ReadVoidPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(pointer: UnsafePointer<Pointee>, order: StoreMemoryOrder = .relaxed)
  {
    StoreVoidPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(pointer: UnsafePointer<Pointee>, order: MemoryOrder = .relaxed) -> UnsafePointer<Pointee>
  {
    return UnsafePointer(SwapVoidPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always)
  public mutating func CAS(current current: UnsafePointer<Pointee>, future: UnsafePointer<Pointee>,
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
  private var ptr: UnsafeMutablePointer<Void>
  public init(_ ptr: COpaquePointer = nil) { self.ptr = UnsafeMutablePointer(ptr) }
  public init(nilLiteral: ()) { self.ptr = nil }

  public var pointer: COpaquePointer {
    mutating get { return COpaquePointer(ReadVoidPtr(&ptr, memory_order_relaxed)) }
    mutating set { StoreVoidPtr(UnsafePointer(newValue), &ptr, memory_order_relaxed) }
  }
}

extension AtomicOpaquePointer
{
  @inline(__always)
  public mutating func load(order: LoadMemoryOrder = .relaxed) -> COpaquePointer
  {
    return COpaquePointer(ReadVoidPtr(&ptr, order.order))
  }

  @inline(__always)
  public mutating func store(pointer: COpaquePointer, order: StoreMemoryOrder = .relaxed)
  {
    StoreVoidPtr(UnsafePointer(pointer), &ptr, order.order)
  }

  @inline(__always)
  public mutating func swap(pointer: COpaquePointer, order: MemoryOrder = .relaxed) -> COpaquePointer
  {
    return COpaquePointer(SwapVoidPtr(UnsafePointer(pointer), &ptr, order.order))
  }

  @inline(__always)
  public mutating func CAS(current current: COpaquePointer, future: COpaquePointer,
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
