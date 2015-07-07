//
//  better-cas.swift
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

import Darwin.libkern.OSAtomic

@inline(__always) public func CAS<T>(o: UnsafeMutablePointer<T>, _ n: UnsafeMutablePointer<T>,
                                     _ p: UnsafeMutablePointer<UnsafeMutablePointer<T>>) -> Bool
{
  return OSAtomicCompareAndSwapPtrBarrier(o, n, UnsafeMutablePointer(p))
}

@inline(__always) public func CAS<T>(o: UnsafePointer<T>, _ n: UnsafePointer<T>,
                                     _ p: UnsafeMutablePointer<UnsafePointer<T>>) -> Bool
{
  return OSAtomicCompareAndSwapPtrBarrier(UnsafeMutablePointer(o), UnsafeMutablePointer(n), UnsafeMutablePointer(p))
}

@inline(__always) public func CAS(o: Int, _ n: Int, _ p: UnsafeMutablePointer<Int>) -> Bool
{
  return OSAtomicCompareAndSwapLongBarrier(o, n, p)
}

@inline(__always) public func CAS(o: UInt, _ n: UInt, _ p: UnsafeMutablePointer<UInt>) -> Bool
{
  return OSAtomicCompareAndSwapLongBarrier(unsafeBitCast(o, Int.self), unsafeBitCast(n, Int.self), UnsafeMutablePointer(p))
}

@inline(__always) public func CAS(o: Int32, _ n: Int32, _ p: UnsafeMutablePointer<Int32>) -> Bool
{
  return OSAtomicCompareAndSwap32Barrier(o, n, p)
}

@inline(__always) public func CAS(o: UInt32, _ n: UInt32, _ p: UnsafeMutablePointer<UInt32>) -> Bool
{
  return OSAtomicCompareAndSwap32Barrier(unsafeBitCast(o, Int32.self), unsafeBitCast(n, Int32.self), UnsafeMutablePointer(p))
}

@inline(__always) public func CAS(o: Int64, _ n: Int64, _ p: UnsafeMutablePointer<Int64>) -> Bool
{
  return OSAtomicCompareAndSwap64Barrier(o, n, p)
}

@inline(__always) public func CAS(o: UInt64, _ n: UInt64, _ p: UnsafeMutablePointer<UInt64>) -> Bool
{
  return OSAtomicCompareAndSwap64Barrier(unsafeBitCast(o, Int64.self), unsafeBitCast(n, Int64.self), UnsafeMutablePointer(p))
}
