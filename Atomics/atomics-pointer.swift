//
//  atomics-pointer.swift
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright © 2015, 2016 Guillaume Lessard. All rights reserved.
//

import clang_atomics

// MARK: Pointer Atomics

extension UnsafeMutablePointer
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UnsafeMutablePointer>) -> UnsafeMutablePointer<UnsafeMutablePointer<Void>>
  {
    return UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UnsafeMutablePointer
  {
    return synchronized ? UnsafeMutablePointer(SyncReadVoidPtr(ptr(&self))) : UnsafeMutablePointer(ReadVoidPtr(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UnsafeMutablePointer, synchronized: Bool = true)
  {
    synchronized ? SyncStoreVoidPtr(v, ptr(&self)) : StoreVoidPtr(v, ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UnsafeMutablePointer) -> UnsafeMutablePointer
  {
    return UnsafeMutablePointer(SwapVoidPtr(v, ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UnsafeMutablePointer, future: UnsafeMutablePointer) -> Bool
  {
    var expect = current
    return CASVoidPtr(ptr(&expect), future, ptr(&self))
  }
}

extension UnsafePointer
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UnsafePointer>) -> UnsafeMutablePointer<UnsafeMutablePointer<Void>>
  {
    return UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UnsafePointer
  {
    return synchronized ? UnsafePointer(SyncReadVoidPtr(ptr(&self))) : UnsafePointer(ReadVoidPtr(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UnsafePointer, synchronized: Bool = true)
  {
    synchronized ? SyncStoreVoidPtr(UnsafeMutablePointer(v), ptr(&self)) : StoreVoidPtr(UnsafeMutablePointer(v), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UnsafePointer) -> UnsafePointer
  {
    return UnsafePointer(SwapVoidPtr(v, ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UnsafePointer, future: UnsafePointer) -> Bool
  {
    var expect = current
    return CASVoidPtr(ptr(&expect), UnsafeMutablePointer(future), ptr(&self))
  }
}

extension COpaquePointer
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<COpaquePointer>) -> UnsafeMutablePointer<UnsafeMutablePointer<Void>>
  {
    return UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> COpaquePointer
  {
    return synchronized ? COpaquePointer(SyncReadVoidPtr(ptr(&self))) : COpaquePointer(ReadVoidPtr(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: COpaquePointer, synchronized: Bool = true)
  {
    synchronized ? SyncStoreVoidPtr(UnsafeMutablePointer(v), ptr(&self)) : StoreVoidPtr(UnsafeMutablePointer(v), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: COpaquePointer) -> COpaquePointer
  {
    return COpaquePointer(SwapVoidPtr(UnsafeMutablePointer<Void>(v), ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: COpaquePointer, future: COpaquePointer) -> Bool
  {
    var expect = current
    return CASVoidPtr(ptr(&expect), UnsafeMutablePointer(future), ptr(&self))
  }
}
