# swift-atomics
Some atomic functions from Clang in Swift

The atomic functions available in `/usr/include/libkern/OSAtomic.h` are quite limiting in Swift, due to the type system. Furthermore, some simple things such as a synchronized load or a synchronized store are not immediately available.

Clang, on the other hand, has an implementation of the C11 atomic functions built-in. This project bridges a subset of Clang's C11 atomics support to Swift.

The following Swift types are extended:
- `UnsafePointer`, `UnsafeMutablePointer` and `COpaquePointer`,
- `Int` and `UInt`, `Int32` and `UInt32`, `Int64` and `UInt64`.

The pointer types have the following methods added:
- `atomicRead`, `atomicStore`, `atomicSwap` and `CAS`

The integer types have the following methods added:
- `atomicRead`, `atomicStore`, `atomicSwap`, `CAS`, `atomicAdd`, `atomicSub`, `increment` and `decrement`.

All operations are bridged in their sequentially-consistent variant (using the `memory_order_seq_cst` attribute.)
The `atomicRead` and `atomicStore` methods can also be called using the quicker `memory_order_relaxed` attribute by setting their optional `synchronized` parameter to `false`.
