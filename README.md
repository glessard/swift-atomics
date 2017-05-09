# swift-atomics [![Build Status](https://travis-ci.org/glessard/swift-atomics.svg?branch=master)](https://travis-ci.org/glessard/swift-atomics)
Some atomic functions from Clang in Swift

The atomic functions available in `/usr/include/libkern/OSAtomic.h` are quite limiting in Swift, due to the type system. Furthermore, some simple things such as a synchronized load or a synchronized store are not immediately available. On top of that, they have now been deprecated.

Clang, on the other hand, has an implementation of the C11 atomic functions built-in. They're also available on Linux.

This project bridges a subset of Clang's C11 atomics support to Swift.

The following Swift types are implemented:
- `AtomicPointer`, `AtomicMutablePointer`, `AtomicRawPointer`, `AtomicMutableRawPointer` and `AtomicOpaquePointer`;
- `AtomicInt` and `AtomicUInt`, `AtomicInt32` and `AtomicUInt32`, `AtomicInt64` and `AtomicUInt64`;
- `AtomicBool`

The pointer types have the following methods:
- `load`, `store`, `swap` and `CAS`

The integer types have the following methods:
- `load`, `store`, `swap`, `CAS`, `add`, `subtract`, `increment`, `decrement`, `bitwiseAnd`, `bitwiseOr` and `bitwiseXor`

The memory order (from `<stdatomic.h>`) can be set by using the `order` parameter on each method; the default is `.relaxed` for the integer types (it is sufficient for counter operations, the most common application,) and `.sequential` for pointer types.

The integer types also have a `value` property, as a convenient way to perform a `.relaxed` load. The pointer types have a `pointer` property for the same purpose.

These types should be used as members of reference types, or captured by closures. They are implemented as `struct`s so that using them does not incur an additional memory allocation. They are not usable as members of a `struct` because that would result in violations the law-of-exclusivity.
