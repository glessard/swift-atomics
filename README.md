# swift-atomics [![Build Status](https://travis-ci.org/glessard/swift-atomics.svg?branch=master)](https://travis-ci.org/glessard/swift-atomics)
Some atomic functions made available to Swift thanks to Clang

The atomic functions available in `/usr/include/libkern/OSAtomic.h` are quite limiting in Swift, due to the type system. Furthermore, some simple things such as a synchronized load or a synchronized store are not immediately available. On top of that, they have now been deprecated.

Clang, on the other hand, has an implementation of the C11 atomic functions built-in. They're also available on Linux.

This project bridges a subset of Clang's C11 atomics support to Swift, as two modules.

### Module SwiftAtomics

`SwiftAtomics` has a swift-style interface to provide access to atomic operations.
`SwiftAtomics` implements the following types:
- `AtomicPointer`, `AtomicMutablePointer`, `AtomicRawPointer`, `AtomicMutableRawPointer` and `AtomicOpaquePointer`;
- `AtomicInt` and `AtomicUInt`, as well as versions signed and unsigned of the 8-bit, 16-bit, 32-bit and 64-bit integer types;
- `AtomicBool`

The pointer types have the following methods:
- `load`, `store`, `swap`, and `CAS`

The integer types have the following methods:
- `load`, `store`, `swap`, `CAS`, `add`, `subtract`, `increment`, `decrement`, `bitwiseAnd`, `bitwiseOr`, and `bitwiseXor`

`AtomicBool` has the following methods:
- `load`, `store`, `swap`, `CAS`, `and`, `or`, and `xor`.

The memory order (from `<stdatomic.h>`) can be set by using the `order` parameter on each method; the default is `.relaxed` for the integer types (it is sufficient for counter operations, the most common application,) and `.sequential` for pointer types.

The integer types also have a `value` property, as a convenient way to perform a `.relaxed` load. The pointer types have a `pointer` property for the same purpose.

### Module CAtomics

The second module is `CAtomics`, which provides atomics to Swift using a C-style interface. `SwiftAtomics` is built on top of `CAtomics`. The types implemented in `CAtomics` are the same as in `SwiftAtomics`, minus the types which use generics features.
Fuctions defined in `CAtomics` are prefixed with `CAtomics`; they are `Load`, `Store`, `Exchange`, and `CompareAndExchange` for all types. The integer types add `Add`, `Subtract`, `BitwiseAnd`, `BitWiseOr`, and `BitWiseXor`; `AtomicBool` adds `And`, `Or`, and `Xor`.

#### Notes on atomics and the law-of-exclusivity:

My experimentation has shown that these types are compatible with Swift 5's run-time exclusivity checking when used as members of class instances, but present difficulties when the thread sanitizer is enabled.

Atomic types are useful as synchronization points between threads, and therefore have an interesting relationship with Swift's exclusivity checking. Firstly, they should be used as members of reference types, or directly captured by closures. They are `struct` types, so as to be not incur additional memory allocation, but that feature means that if you use the thread sanitizer, it will warn about them.

In order to use atomics in a way that is acceptable to the thread sanitizer; you must allocate memory for atomic variables on the heap using `UnsafeMutablePointer`, and then pass that pointer to the `CAtomics` functions as needed. Unfortunately I have not found a way to use the swift-style wrappers in a way that doesn't trigger the thread sanitizer.

```swift
class Example {
  private var state = UnsafeMutablePointer<AtomicInt>.allocate(capacity: 1)
  init() {
    CAtomicsInitialize(state, 0)
  }

  deinit {
    state.deallocate()
  }

  func increment(by value: Int = 1) {
    CAtomicsAdd(state, value, .relaxed)
  }
}
```

#### Requirements

This library requires Swift 3.1 or later. On Linux, it also requires Clang 3.6 or later.
