# swift-atomics
Some atomic functions from Clang in Swift

The atomic functions available in `/usr/include/libkern/OSAtomic.h` are quite limiting in Swift, due to the type system. Furthermore, some simple things such as a synchronized load or a synchronized store are not immediately available.

Clang, on the other hand, has an implementation of the C11 atomic functions built-in. This project bridges a subset of Clang's C11 atomics support to Swift.

Supported Swift types are `UnsafePointer`, `UnsafeMutablePointer`, `Int` and `UInt`, `Int32` and `UInt32`, `Int64` and `UInt64`.
All operations are bridged in their sequentially-consistent variant (using the `memory_order_seq_cst` attribute.) Read and Store also have a `memory_order_relaxed` variant bridged.
