//
//  CAtomicsReferenceTests.swift
//  CAtomicsTests
//
//  Created by Guillaume Lessard on 10/10/18.
//  Copyright © 2018 Guillaume Lessard. All rights reserved.
//

import XCTest
import Dispatch

import CAtomics

private enum TestError: Error { case value(UInt) }

private class Thing
{
  let id: UInt
  init(_ x: UInt) { id = x }
}

private class Witness: Thing
{
  override init(_ x: UInt) { super.init(x) }
  deinit { print("Released  \(id)") }
}

public class UnmanagedTests: XCTestCase
{
  public func testUnmanaged()
  {
    var i = UInt.randomPositive()
    var u = Unmanaged.passRetained(Witness(i))
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, u.toOpaque())
    do {
      let p = CAtomicsExchange(&a, nil, .relaxed)
      print("Releasing \(i)")
      XCTAssert(p != nil)
      let r = p.map(Unmanaged<Witness>.fromOpaque)?.takeRetainedValue()
      XCTAssert(r != nil)
    }
    XCTAssert(CAtomicsIsLockFree(&a))

    i = UInt.randomPositive()
    u = Unmanaged.passRetained(Witness(i))
    XCTAssert(CAtomicsExchange(&a, u.toOpaque(), .release) == nil)
    print("Releasing \(i)")
    let p = CAtomicsExchange(&a, nil, .acquire)
    XCTAssert(p != nil)
    _ = p.map(Unmanaged<Witness>.fromOpaque)?.takeRetainedValue()

    i = UInt.randomPositive()
    u = Unmanaged.passRetained(Witness(i))
    XCTAssertTrue( CAtomicsCompareAndExchange(&a, nil, u.toOpaque(), .strong, .release))
    XCTAssertFalse(CAtomicsCompareAndExchange(&a, nil, u.toOpaque(), .weak, .relaxed))

    let v = CAtomicsUnmanagedLockAndLoad(&a, .acquire)
    XCTAssert(v != nil)
    XCTAssert(v == UnsafeRawPointer(u.toOpaque()))
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))
    CAtomicsStore(&a, v, .release)

    let j = UInt.randomPositive()
    u = Unmanaged.passRetained(Witness(j))
    XCTAssertFalse(CAtomicsCompareAndExchange(&a, nil, u.toOpaque(), .strong, .relaxed))
    XCTAssertTrue( CAtomicsCompareAndExchange(&a, v, u.toOpaque(), .strong, .relaxed))
    print("Releasing \(i)")
    v.map(Unmanaged<Witness>.fromOpaque)?.release()
    while !CAtomicsCompareAndExchange(&a, u.toOpaque(), nil, .weak, .relaxed) {}
    print("Releasing \(j)")
    u.release()
  }

  public func testSpinLoad()
  {
    let i = UInt.randomPositive()
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, Unmanaged.passRetained(Thing(i)).toOpaque())

    let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))

    let e = expectation(description: "load and relock after unlock")
    DispatchQueue.global().async {
      if let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
      {
        let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
        XCTAssert(t.id == i)
        e.fulfill()
      }
    }

    DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: { CAtomicsStore(&a, p, .release) })
    waitForExpectations(timeout: 1.0)

    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))
  }

  public func testSpinTake()
  {
    let i = UInt.randomPositive()
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, Unmanaged.passRetained(Thing(i)).toOpaque())

    let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))

    let e = expectation(description: "swap-to-nil after unlock")
    DispatchQueue.global().async {
      if let p = CAtomicsExchange(&a, nil, .relaxed)
      {
        let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
        XCTAssert(t.id == i)
        e.fulfill()
      }
    }

    DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: { CAtomicsStore(&a, p, .release) })
    waitForExpectations(timeout: 1.0)

    XCTAssert(CAtomicsLoad(&a, .relaxed) == nil)
  }

  public func testSpinSwap() throws
  {
    let i = UInt.randomPositive()
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, Unmanaged.passRetained(Thing(i)).toOpaque())

    let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))

    let j = UInt.randomPositive()
    let e = expectation(description: "arbitrary swap after unlock")
    DispatchQueue.global().async {
      if let p = CAtomicsExchange(&a, Unmanaged.passRetained(Thing(j)).toOpaque(), .relaxed)
      {
        let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
        XCTAssert(t.id == i)
        e.fulfill()
      }
    }

    DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: { CAtomicsStore(&a, p, .release) })
    waitForExpectations(timeout: 1.0)

    XCTAssert(CAtomicsLoad(&a, .relaxed) != nil)
    if let p = CAtomicsLoad(&a, .relaxed)
    {
      let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
      XCTAssert(t.id == j)
    }
    else { throw TestError.value(j) }
  }

  public func testSafeStoreSuccess() throws
  {
    let i = UInt.randomPositive()
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, Unmanaged.passRetained(Thing(i)).toOpaque())

    let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))

    let j = UInt.randomPositive()
    let e = expectation(description: "succeed at swapping for nil")
    DispatchQueue.global().async {
      let stored = CAtomicsCompareAndExchange(&a, nil, Unmanaged.passRetained(Thing(j)).toOpaque(), .strong, .relaxed)
      XCTAssert(stored)
      e.fulfill()
    }

    DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: { CAtomicsStore(&a, nil, .release) })
    waitForExpectations(timeout: 1.0)

    XCTAssert(CAtomicsLoad(&a, .relaxed) != nil)
    if let p = CAtomicsLoad(&a, .relaxed)
    {
      let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
      XCTAssert(t.id == j)
    }
    else { throw TestError.value(j) }
    if let p = p
    {
      let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
      XCTAssert(t.id == i)
    }
    else { throw TestError.value(i) }
  }

  public func testSafeStoreFailure() throws
  {
    let i = UInt.randomPositive()
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, Unmanaged.passRetained(Thing(i)).toOpaque())

    let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))

    let t = Thing(0)
    let e = expectation(description: "failure to swap for nil")
    DispatchQueue.global().async {
      let stored = CAtomicsCompareAndExchange(&a, nil, Unmanaged.passUnretained(t).toOpaque(), .strong, .relaxed)
      XCTAssert(!stored)
      e.fulfill()
    }

    DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: { CAtomicsStore(&a, p, .release) })
    waitForExpectations(timeout: 1.0)

    XCTAssert(CAtomicsLoad(&a, .relaxed) != nil)
    if let p = CAtomicsLoad(&a, .relaxed)
    {
      let t = Unmanaged<Thing>.fromOpaque(p).takeRetainedValue()
      XCTAssert(t.id == i)
    }
    else { throw TestError.value(i) }
  }

  public func testCasBlocked() throws
  {
    let i = UInt.randomPositive()
    let j = UInt.randomPositive()
    var a = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&a, Unmanaged.passRetained(Thing(i)).toOpaque())

    let p = CAtomicsUnmanagedLockAndLoad(&a, .relaxed)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))

    let e = expectation(description: "succeed at strong CAS")
    DispatchQueue.global().async {
      let f = Unmanaged.passRetained(Thing(j)).toOpaque()
      XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(bitPattern: 0x7))
      while !CAtomicsCompareAndExchange(&a, p, f, .weak, .sequential) {}
      XCTAssert(CAtomicsLoad(&a, .relaxed) == UnsafeRawPointer(f))
      e.fulfill()
    }

    DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute: { CAtomicsStore(&a, p, .release) })
    waitForExpectations(timeout: 1.0)

    XCTAssert(CAtomicsExchange(&a, nil, .acquire) != nil)
    XCTAssert(CAtomicsLoad(&a, .relaxed) == nil)
  }

  public func testDemonstrateWhyLockIsNecessary() throws
  {
    let i = UInt.randomPositive()

    var atomic = OpaqueUnmanagedHelper()
    CAtomicsInitialize(&atomic, Unmanaged.passRetained(Witness(i)).toOpaque())

    // this is a weird simulation of two threads racing to interact
    // with an object stored in an "atomic reference".
    // mock thread A wants to read the value stored in the object.
    // mock thread B decrements the object's reference count.

    // mock thread A needs a copy of the reference
    guard let pointerA = CAtomicsLoad(&atomic, .acquire)
      else { throw TestError.value(0) }
    // mock thread A is interrupted

    // mock thread B resumes execution
    guard let pointerB = CAtomicsExchange(&atomic, nil, .acquire)
      else { throw TestError.value(1) }

    print("Releasing \(i)")
    Unmanaged<Witness>.fromOpaque(pointerB).release()
    // mock thread B is done

    XCTAssert(CAtomicsLoad(&atomic, .relaxed) == nil)
    XCTAssertEqual(pointerA, pointerB)

    // mock thread A resumes execution
    // it does not know (and has no way to know)
    // that the object has been released.
    let u = Unmanaged<Witness>.fromOpaque(pointerA)
    _ = u
    // when un-commented, the next line causes a use-after-free error
    // let w = u.takeRetainedValue()
    // print("Reading   \(w.id)")

    // the following causes an immediate use-after-free crash
    // u.release()

    // this is similar to the Swift 2 runtime bug
    // https://bugs.swift.org/browse/SR-192
    // the only way to fix that -- short of a redesign --
    // was to lock weak references while being copied.
  }
}

private let iterations = 200_000//_000

public class UnmanagedRaceTests: XCTestCase
{
  public func testRaceAtomickishUnmanaged()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      var r = OpaqueUnmanagedHelper()
      CAtomicsInitialize(&r, {
        () -> UnsafeMutableRawPointer in
        let b = ManagedBuffer<Int, Int>.create(minimumCapacity: 1, makingHeaderWith: { _ in 1 })
        let u = Unmanaged.passRetained(b)
        return u.toOpaque()
      }())
      let closure = {
        while true
        {
          if let p = CAtomicsExchange(&r, nil, .relaxed)
          {
            let buffer = Unmanaged<ManagedBuffer<Int, Int>>.fromOpaque(p).takeRetainedValue()
            XCTAssert(buffer.header == 1)
          }
          else
          {
            XCTAssert(CAtomicsLoad(&r, .relaxed) == nil)
            break
          }
        }
      }

      q.async(execute: closure)
      q.async(execute: closure)
    }

    q.sync(flags: .barrier) {}
  }

  public func testRaceLoadVersusDeinit()
  {
    let q = DispatchQueue(label: "", attributes: .concurrent)

    for _ in 1...iterations
    {
      let a = UnsafeMutablePointer<OpaqueUnmanagedHelper>.allocate(capacity: 1)
      CAtomicsInitialize(a, Unmanaged.passRetained(Thing(.randomPositive())).toOpaque())

      let closure = {
        (b: Bool) -> () -> Void in
        return {
          () -> Void in
          var c = b
          while true
          {
            if c
            {
              if let t = CAtomicsUnmanagedLockAndLoad(a, .acquire)
              {
                let u = Unmanaged<Thing>.fromOpaque(t).retain()
                CAtomicsStore(a, t, .release)
                let thing = u.takeRetainedValue()
                XCTAssertNotEqual(thing.id, 0)
              }
              else
              {
                return
              }
            }
            else
            {
              if let t = CAtomicsExchange(a, nil, .acquire)
              {
                let u = Unmanaged<Thing>.fromOpaque(t).retain()
                let thing = u.takeRetainedValue()
                XCTAssertNotEqual(thing.id, 0)
              }
              else
              {
                return
              }
            }
            c = !c
          }
        }
      }

      q.async(execute: closure(true))
      q.async(execute: closure(false))
      q.async(flags: .barrier) {
#if swift(>=4.1)
        a.deallocate()
#else
        a.deallocate(capacity: 1)
#endif
      }
    }

    q.sync(flags: .barrier, execute: {})
  }
}
