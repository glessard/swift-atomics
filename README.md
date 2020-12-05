# swift-atomics [![Build Status](https://travis-ci.org/glessard/swift-atomics.svg?branch=main)](https://travis-ci.org/glessard/swift-atomics)
Some atomic functions made available to Swift, thanks to Clang.

NOTE: This package is deprecated in favor of the official atomics preview package, [Swift Atomics](https://github.com/apple/swift-atomics).

The atomic functions available in `/usr/include/libkern/OSAtomic.h` are quite limiting in Swift, due to impedance mismatches between the type systems of Swift and C. Furthermore, some simple things such as a synchronized load or a synchronized store are not immediately available. On top of that, they have now been deprecated.

Clang, of course, implements the C11 atomic functions &mdash; and they're available on Linux.

This project bridges a subset of Clang's C11 atomics support to Swift, as two modules.

The latest version (6.5.0) supports Swift 4.0 and up.
Version 6.2.3 of this package supports versions of Swift as far back as 3.1.1

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

#### Notes on atomics and the law-of-exclusivity:

Atomic types are useful as synchronization points between threads, and therefore have an interesting relationship with Swift's exclusivity checking. They should be used as members of reference types, or directly captured by closures. They are `struct` types, so as to be not incur additional memory allocation, but that feature means that if you use the thread sanitizer, it will warn about them.

The types defined in `SwiftAtomics` work as expected with Swift 5's run-time exclusivity checking when used as members of class instances, but present difficulties when the thread sanitizer is enabled.

In order to use atomics in a way that is acceptable to the thread sanitizer, one must have allocated memory for atomic variables on the heap using `UnsafeMutablePointer`. If you require compatibility with the thread sanitizer, it is best to use the underlying dependency [`CAtomics`](https://github.com/glessard/CAtomics) directly or, even better, the official [`SwiftAtomics`](https://github.com/apple/swift-atomics) atomics preview package.

#### Requirements

This version of `SwiftAtomics` requires Swift 4.0 or later.
