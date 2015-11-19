//
//  clang-atomics.swift
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

import clangatomics

// MARK: Pointer Atomics

@inline(__always) public func Read<T>(p: UnsafeMutablePointer<UnsafePointer<T>>) -> UnsafePointer<T>
{
  return UnsafePointer<T>(ReadVoidPtr(UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)))
}

@inline(__always) public func Read<T>(p: UnsafeMutablePointer<UnsafeMutablePointer<T>>) -> UnsafeMutablePointer<T>
{
  return UnsafeMutablePointer<T>(ReadVoidPtr(UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)))
}


@inline(__always) public func SyncRead<T>(p: UnsafeMutablePointer<UnsafePointer<T>>) -> UnsafePointer<T>
{
  return UnsafePointer<T>(SyncReadVoidPtr(UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)))
}

@inline(__always) public func SyncRead<T>(p: UnsafeMutablePointer<UnsafeMutablePointer<T>>) -> UnsafeMutablePointer<T>
{
  return UnsafeMutablePointer<T>(SyncReadVoidPtr(UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)))
}


@inline(__always) public func Store<T>(v: UnsafePointer<T>, _ p: UnsafeMutablePointer<UnsafePointer<T>>)
{
  StoreVoidPtr(v, UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p))
}

@inline(__always) public func Store<T>(v: UnsafeMutablePointer<T>, _ p: UnsafeMutablePointer<UnsafeMutablePointer<T>>)
{
  StoreVoidPtr(v, UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p))
}


@inline(__always) public func SyncStore<T>(v: UnsafePointer<T>, _ p: UnsafeMutablePointer<UnsafePointer<T>>)
{
  SyncStoreVoidPtr(v, UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p))
}

@inline(__always) public func SyncStore<T>(v: UnsafeMutablePointer<T>, _ p: UnsafeMutablePointer<UnsafeMutablePointer<T>>)
{
  SyncStoreVoidPtr(v, UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p))
}


@inline(__always) public func Swap<T>(v: UnsafePointer<T>, _ p: UnsafeMutablePointer<UnsafePointer<T>>) -> UnsafePointer<T>
{
  return UnsafePointer<T>(SwapVoidPtr(v, UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)))
}

@inline(__always) public func Swap<T>(v: UnsafePointer<T>, _ p: UnsafeMutablePointer<UnsafeMutablePointer<T>>) -> UnsafeMutablePointer<T>
{
  return UnsafeMutablePointer<T>(SwapVoidPtr(v, UnsafeMutablePointer<UnsafeMutablePointer<Void>>(p)))
}


// MARK: Int and UInt Atomics

@inline(__always) public func Read(p: UnsafeMutablePointer<Int>) -> Int
{
  return ReadWord(p)
}

@inline(__always) public func Read(p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: ReadWord(UnsafeMutablePointer(p)))
}

@inline(__always) public func SyncRead(p: UnsafeMutablePointer<Int>) -> Int
{
  return SyncReadWord(p)
}

@inline(__always) public func SyncRead(p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: SyncReadWord(UnsafeMutablePointer(p)))
}

@inline(__always) public func Store(v: Int, _ p: UnsafeMutablePointer<Int>)
{
  StoreWord(v, p)
}

@inline(__always) public func Store(v: UInt, _ p: UnsafeMutablePointer<UInt>)
{
  StoreWord(unsafeBitCast(v, Int.self), UnsafeMutablePointer(p))
}

@inline(__always) public func SyncStore(v: Int, _ p: UnsafeMutablePointer<Int>)
{
  SyncStoreWord(v, p)
}

@inline(__always) public func SyncStore(v: UInt, _ p: UnsafeMutablePointer<UInt>)
{
  SyncStoreWord(unsafeBitCast(v, Int.self), UnsafeMutablePointer(p))
}

@inline(__always) public func Swap(v: Int, _ p: UnsafeMutablePointer<Int>) -> Int
{
  return SwapWord(v, p)
}

@inline(__always) public func Swap(v: UInt, _ p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: SwapWord(unsafeBitCast(v, Int.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Add(i: Int, to p: UnsafeMutablePointer<Int>) -> Int
{
  return AddWord(i, p)
}

@inline(__always) public func Add(i: UInt, to p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: AddWord(unsafeBitCast(i, Int.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Sub(i: Int, from p: UnsafeMutablePointer<Int>) -> Int
{
  return SubWord(i, p)
}

@inline(__always) public func Sub(i: UInt, from p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: SubWord(unsafeBitCast(i, Int.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Increment(p: UnsafeMutablePointer<Int>) -> Int
{
  return IncrementWord(p)
}

@inline(__always) public func Increment(p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: IncrementWord(UnsafeMutablePointer(p)))
}

@inline(__always) public func Decrement(p: UnsafeMutablePointer<Int>) -> Int
{
  return DecrementWord(p)
}

@inline(__always) public func Decrement(p: UnsafeMutablePointer<UInt>) -> UInt
{
  return UInt(bitPattern: DecrementWord(UnsafeMutablePointer(p)))
}

// MARK: Int32 and UInt32 Atomics

@inline(__always) public func Read(p: UnsafeMutablePointer<Int32>) -> Int32
{
  return Read32(p)
}

@inline(__always) public func Read(p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: Read32(UnsafeMutablePointer(p)))
}

@inline(__always) public func SyncRead(p: UnsafeMutablePointer<Int32>) -> Int32
{
  return SyncRead32(p)
}

@inline(__always) public func SyncRead(p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: SyncRead32(UnsafeMutablePointer(p)))
}

@inline(__always) public func Store(v: Int32, _ p: UnsafeMutablePointer<Int32>)
{
  Store32(v, p)
}

@inline(__always) public func Store(v: UInt32, _ p: UnsafeMutablePointer<UInt32>)
{
  Store32(unsafeBitCast(v, Int32.self), UnsafeMutablePointer(p))
}

@inline(__always) public func SyncStore(v: Int32, _ p: UnsafeMutablePointer<Int32>)
{
  SyncStore32(v, p)
}

@inline(__always) public func SyncStore(v: UInt32, _ p: UnsafeMutablePointer<UInt32>)
{
  SyncStore32(unsafeBitCast(v, Int32.self), UnsafeMutablePointer(p))
}

@inline(__always) public func Swap(v: Int32, _ p: UnsafeMutablePointer<Int32>) -> Int32
{
  return Swap32(v, p)
}

@inline(__always) public func Swap(v: UInt32, _ p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: Swap32(unsafeBitCast(v, Int32.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Add(i: Int32, to p: UnsafeMutablePointer<Int32>) -> Int32
{
  return Add32(i, p)
}

@inline(__always) public func Add(i: UInt32, to p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: Add32(unsafeBitCast(i, Int32.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Sub(i: Int32, from p: UnsafeMutablePointer<Int32>) -> Int32
{
  return Sub32(i, p)
}

@inline(__always) public func Sub(i: UInt32, from p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: Sub32(unsafeBitCast(i, Int32.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Increment(p: UnsafeMutablePointer<Int32>) -> Int32
{
  return Increment32(p)
}

@inline(__always) public func Increment(p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: Increment32(UnsafeMutablePointer(p)))
}

@inline(__always) public func Decrement(p: UnsafeMutablePointer<Int32>) -> Int32
{
  return Decrement32(p)
}

@inline(__always) public func Decrement(p: UnsafeMutablePointer<UInt32>) -> UInt32
{
  return UInt32(bitPattern: Decrement32(UnsafeMutablePointer(p)))
}

// MARK: Int64 and UInt64 Atomics

@inline(__always) public func Read(p: UnsafeMutablePointer<Int64>) -> Int64
{
  return Read64(p)
}

@inline(__always) public func Read(p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: Read64(UnsafeMutablePointer(p)))
}

@inline(__always) public func SyncRead(p: UnsafeMutablePointer<Int64>) -> Int64
{
  return SyncRead64(p)
}

@inline(__always) public func SyncRead(p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: SyncRead64(UnsafeMutablePointer(p)))
}

@inline(__always) public func Store(v: Int64, _ p: UnsafeMutablePointer<Int64>)
{
  Store64(v, p)
}

@inline(__always) public func Store(v: UInt64, _ p: UnsafeMutablePointer<UInt64>)
{
  Store64(unsafeBitCast(v, Int64.self), UnsafeMutablePointer(p))
}

@inline(__always) public func SyncStore(v: Int64, _ p: UnsafeMutablePointer<Int64>)
{
  SyncStore64(v, p)
}

@inline(__always) public func SyncStore(v: UInt64, _ p: UnsafeMutablePointer<UInt64>)
{
  SyncStore64(unsafeBitCast(v, Int64.self), UnsafeMutablePointer(p))
}

@inline(__always) public func Swap(v: Int64, _ p: UnsafeMutablePointer<Int64>) -> Int64
{
  return Swap64(v, p)
}

@inline(__always) public func Swap(v: UInt64, _ p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: Swap64(unsafeBitCast(v, Int64.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Add(i: Int64, to p: UnsafeMutablePointer<Int64>) -> Int64
{
  return Add64(i, p)
}

@inline(__always) public func Add(i: UInt64, to p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: Add64(unsafeBitCast(i, Int64.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Sub(i: Int64, from p: UnsafeMutablePointer<Int64>) -> Int64
{
  return Sub64(i, p)
}

@inline(__always) public func Sub(i: UInt64, from p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: Sub64(unsafeBitCast(i, Int64.self), UnsafeMutablePointer(p)))
}

@inline(__always) public func Increment(p: UnsafeMutablePointer<Int64>) -> Int64
{
  return Increment64(p)
}

@inline(__always) public func Increment(p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: Increment64(UnsafeMutablePointer(p)))
}

@inline(__always) public func Decrement(p: UnsafeMutablePointer<Int64>) -> Int64
{
  return Decrement64(p)
}

@inline(__always) public func Decrement(p: UnsafeMutablePointer<UInt64>) -> UInt64
{
  return UInt64(bitPattern: Decrement64(UnsafeMutablePointer(p)))
}
