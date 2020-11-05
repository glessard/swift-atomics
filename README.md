# swift-atomics [![Build Status](https://travis-ci.org/glessard/swift-atomics.svg?branch=main)](https://travis-ci.org/glessard/swift-atomics)
Some atomic functions made available to Swift 3.1 and up, thanks to Clang

The atomic functions available in `/usr/include/libkern/OSAtomic.h` are quite limiting in Swift, due to impedance mismatches between the type systems of Swift and C. Furthermore, some simple things such as a synchronized load or a synchronized store are not immediately available. On top of that, they have now been deprecated.

Clang, of course, implements the C11 atomic functions &mdash; and they're available on Linux.

This project bridges a subset of Clang's C11 atomics support to Swift, as two modules.

### Module SwiftAtomics

`SwiftAtomics` has a swift-style interface to provide access to atomic operations.
`SwiftAtomics` implements the following types:
- `AtomicPointer`, `AtomicMutablePointer`, `AtomicRawPointer`, `AtomicMutableRawPointer` and `AtomicOpaquePointer`;
- `AtomicInt` and `AtomicUInt`, as well as signed and unsigned versions of the 8-bit, 16-bit, 32-bit and 64-bit integer types;
- `AtomicBool`

The pointer types have the following methods:
- `load`, `store`, `swap`, and `CAS`

The integer types have the following methods:
- `load`, `store`, `swap`, `CAS`, `add`, `subtract`, `increment`, `decrement`, `bitwiseAnd`, `bitwiseOr`, and `bitwiseXor`

`AtomicBool` has the following methods:
- `load`, `store`, `swap`, `CAS`, `and`, `or`, and `xor`.

The memory ordering (from `<stdatomic.h>`) can be set by using the `order` parameter on each method; the defaults are `.acquire` for loading operations, `.release` for storing operations, and `.acqrel` for read-modify-write operations. Note that `memory_order_consume` has no equivalent in this module, as (as far as I can tell) clang silently upgrades that ordering to `memory_order_acquire`, making it impossible (at the moment) to test whether an algorithm can properly use `memory_order_consume`. This also means nothing is lost by its absence.

The integer types have a `value` property, as a convenient way to perform a `.relaxed` load.
The pointer types have a `pointer` property, which performs an `.acquire` load.

### Module CAtomics

The second module is `CAtomics`, which provides atomics to Swift using a C-style interface. `SwiftAtomics` is built on top of `CAtomics`. The types implemented in `CAtomics` are the same as in `SwiftAtomics`, minus those which require Swift's generic features.
Functions defined in `CAtomics` are prefixed with `CAtomics`; they are `Load`, `Store`, `Exchange`, and `CompareAndExchange` for all types. The integer types add `Add`, `Subtract`, `BitwiseAnd`, `BitWiseOr`, and `BitWiseXor`; `AtomicBool` adds `And`, `Or`, and `Xor`.

#### Notes on atomics and the law-of-exclusivity:

My experimentation has shown that the types defined in `SwiftAtomics` are compatible with Swift 5's run-time exclusivity checking when used as members of class instances, but present difficulties when the thread sanitizer is enabled.

Atomic types are useful as synchronization points between threads, and therefore have an interesting relationship with Swift's exclusivity checking. They should be used as members of reference types, or directly captured by closures. They are `struct` types, so as to be not incur additional memory allocation, but that feature means that if you use the thread sanitizer, it will warn about them.

In order to use atomics in a way that is acceptable to the thread sanitizer, one must have allocated memory for atomic variables on the heap using `UnsafeMutablePointer`. Then, pass that pointer to the functions defined in the `CAtomics` module, as needed. I haven't found a way to use the swift-style wrappers in a way that doesn't trigger the thread sanitizer.

```swift
import CAtomics

class Example {
  private var counter = UnsafeMutablePointer<AtomicInt>.allocate(capacity: 1)
  init() {
    CAtomicsInitialize(counter, 0)
  }

  deinit {
    counter.deallocate()
  }

  func increment(by value: Int = 1) {
    CAtomicsAdd(counter, value, .relaxed)
  }
}
```

#### Requirements

This library requires Swift 3.1 or later. On Linux, it also requires Clang 3.6 or later.
