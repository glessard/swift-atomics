//
//  atomics.swift
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
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


// MARK: Int and UInt Atomics

extension Int
{
  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> Int
  {
    return synchronized ? SyncReadWord(&self) : ReadWord(&self)
  }

  @inline(__always) public mutating func atomicStore(v: Int, synchronized: Bool = true)
  {
    synchronized ? SyncStoreWord(v, &self) : StoreWord(v, &self)
  }

  @inline(__always) public mutating func atomicSwap(v: Int) -> Int
  {
    return SwapWord(v, &self)
  }

  @inline(__always) public mutating func atomicAdd(i: Int) -> Int
  {
    return AddWord(i, &self)
  }

  @inline(__always) public mutating func increment() -> Int
  {
    return IncrementWord(&self)
  }

  @inline(__always) public mutating func atomicSub(i: Int) -> Int
  {
    return SubWord(i, &self)
  }

  @inline(__always) public mutating func decrement() -> Int
  {
    return DecrementWord(&self)
  }

  @inline(__always) public mutating func CAS(current current: Int, future: Int) -> Bool
  {
    var expect = current
    return CASWord(&expect, future, &self)
  }
}

extension UInt
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UInt>) -> UnsafeMutablePointer<Int>
  {
    return UnsafeMutablePointer<Int>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UInt
  {
    return synchronized ? UInt(bitPattern: SyncReadWord(ptr(&self))) : UInt(bitPattern: ReadWord(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UInt, synchronized: Bool = true)
  {
    synchronized ? SyncStoreWord(unsafeBitCast(v, Int.self), ptr(&self)) : StoreWord(unsafeBitCast(v, Int.self), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UInt) -> UInt
  {
    return UInt(bitPattern: SwapWord(unsafeBitCast(v, Int.self), ptr(&self)))
  }

  @inline(__always) public mutating func atomicAdd(i: UInt) -> UInt
  {
    return UInt(bitPattern: AddWord(unsafeBitCast(i, Int.self), ptr(&self)))
  }

  @inline(__always) public mutating func increment() -> UInt
  {
    return UInt(bitPattern: IncrementWord(ptr(&self)))
  }

  @inline(__always) public mutating func atomicSub(i: UInt) -> UInt
  {
    return UInt(bitPattern: SubWord(unsafeBitCast(i, Int.self), ptr(&self)))
  }

  @inline(__always) public mutating func decrement() -> UInt
  {
    return UInt(bitPattern: DecrementWord(ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UInt, future: UInt) -> Bool
  {
    var expect = current
    return CASWord(ptr(&expect), unsafeBitCast(future, Int.self), ptr(&self))
  }
}

// MARK: Int32 and UInt32 Atomics

extension Int32
{
  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> Int32
  {
    return synchronized ? SyncRead32(&self) : Read32(&self)
  }

  @inline(__always) public mutating func atomicStore(v: Int32, synchronized: Bool = true)
  {
    synchronized ? SyncStore32(v, &self) : Store32(v, &self)
  }

  @inline(__always) public mutating func atomicSwap(v: Int32) -> Int32
  {
    return Swap32(v, &self)
  }

  @inline(__always) public mutating func atomicAdd(i: Int32) -> Int32
  {
    return Add32(i, &self)
  }

  @inline(__always) public mutating func increment() -> Int32
  {
    return Increment32(&self)
  }

  @inline(__always) public mutating func atomicSub(i: Int32) -> Int32
  {
    return Sub32(i, &self)
  }

  @inline(__always) public mutating func decrement() -> Int32
  {
    return Decrement32(&self)
  }

  @inline(__always) public mutating func CAS(current current: Int32, future: Int32) -> Bool
  {
    var expect = current
    return CAS32(&expect, future, &self)
//    if CAS32(&expect, future, &self)
//    {
//      precondition(expect == current)
//    }
//    else
//    {
//      precondition(expect != current)
//    }
//    return expect == current
  }
}

extension UInt32
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UInt32>) -> UnsafeMutablePointer<Int32>
  {
    return UnsafeMutablePointer<Int32>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UInt32
  {
    return synchronized ? UInt32(bitPattern: SyncRead32(ptr(&self))) : UInt32(bitPattern: Read32(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UInt32, synchronized: Bool = true)
  {
    synchronized ? SyncStore32(unsafeBitCast(v, Int32.self), ptr(&self)) : Store32(unsafeBitCast(v, Int32.self), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UInt32) -> UInt32
  {
    return UInt32(bitPattern: Swap32(unsafeBitCast(v, Int32.self), ptr(&self)))
  }

  @inline(__always) public mutating func atomicAdd(i: UInt32) -> UInt32
  {
    return UInt32(bitPattern: Add32(unsafeBitCast(i, Int32.self), ptr(&self)))
  }

  @inline(__always) public mutating func increment() -> UInt32
  {
    return UInt32(bitPattern: Increment32(ptr(&self)))
  }

  @inline(__always) public mutating func atomicSub(i: UInt32) -> UInt32
  {
    return UInt32(bitPattern: Sub32(unsafeBitCast(i, Int32.self), ptr(&self)))
  }

  @inline(__always) public mutating func decrement() -> UInt32
  {
    return UInt32(bitPattern: Decrement32(ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UInt32, future: UInt32) -> Bool
  {
    var expect = current
    return CAS32(ptr(&expect), unsafeBitCast(future, Int32.self), ptr(&self))
  }
}

// MARK: Int64 and UInt64 Atomics

extension Int64
{
  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> Int64
  {
    return synchronized ? SyncRead64(&self) : Read64(&self)
  }

  @inline(__always) public mutating func atomicStore(v: Int64, synchronized: Bool = true)
  {
    synchronized ? SyncStore64(v, &self) : Store64(v, &self)
  }

  @inline(__always) public mutating func atomicSwap(v: Int64) -> Int64
  {
    return Swap64(v, &self)
  }

  @inline(__always) public mutating func atomicAdd(i: Int64) -> Int64
  {
    return Add64(i, &self)
  }

  @inline(__always) public mutating func increment() -> Int64
  {
    return Increment64(&self)
  }

  @inline(__always) public mutating func atomicSub(i: Int64) -> Int64
  {
    return Sub64(i, &self)
  }

  @inline(__always) public mutating func decrement() -> Int64
  {
    return Decrement64(&self)
  }

  @inline(__always) public mutating func CAS(current current: Int64, future: Int64) -> Bool
  {
    var expect = current
    return CAS64(&expect, future, &self)
  }
}

extension UInt64
{
  @inline(__always) private func ptr(p: UnsafeMutablePointer<UInt64>) -> UnsafeMutablePointer<Int64>
  {
    return UnsafeMutablePointer<Int64>(p)
  }

  @inline(__always) public mutating func atomicRead(synchronized synchronized: Bool = true) -> UInt64
  {
    return synchronized ? UInt64(bitPattern: SyncRead64(ptr(&self))) : UInt64(bitPattern: Read64(ptr(&self)))
  }

  @inline(__always) public mutating func atomicStore(v: UInt64, synchronized: Bool = true)
  {
    synchronized ? SyncStore64(unsafeBitCast(v, Int64.self), ptr(&self)) : Store64(unsafeBitCast(v, Int64.self), ptr(&self))
  }

  @inline(__always) public mutating func atomicSwap(v: UInt64) -> UInt64
  {
    return UInt64(bitPattern: Swap64(unsafeBitCast(v, Int64.self), ptr(&self)))
  }

  @inline(__always) public mutating func atomicAdd(i: UInt64) -> UInt64
  {
    return UInt64(bitPattern: Add64(unsafeBitCast(i, Int64.self), ptr(&self)))
  }

  @inline(__always) public mutating func increment() -> UInt64
  {
    return UInt64(bitPattern: Increment64(ptr(&self)))
  }

  @inline(__always) public mutating func atomicSub(i: UInt64) -> UInt64
  {
    return UInt64(bitPattern: Sub64(unsafeBitCast(i, Int64.self), ptr(&self)))
  }

  @inline(__always) public mutating func decrement() -> UInt64
  {
    return UInt64(bitPattern: Decrement64(ptr(&self)))
  }

  @inline(__always) public mutating func CAS(current current: UInt64, future: UInt64) -> Bool
  {
    var expect = current
    return CAS64(ptr(&expect), unsafeBitCast(future, Int64.self), ptr(&self))
  }
}
