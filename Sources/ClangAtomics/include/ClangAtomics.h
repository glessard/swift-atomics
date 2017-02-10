//
//  clang-atomics.h
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

#ifndef clang_atomics_h
#define clang_atomics_h

#include <stdatomic.h>

// See: http://clang.llvm.org/doxygen/stdatomic_8h_source.html
//      http://clang.llvm.org/docs/LanguageExtensions.html#c11-atomic-builtins
//      http://en.cppreference.com/w/c/atomic
//      http://en.cppreference.com/w/c/atomic/atomic_compare_exchange

// pointer

struct RawPointer
{
  volatile atomic_uintptr_t a;
};

void InitRawPtr(const void* val, struct RawPointer *ptr);
void* ReadRawPtr(struct RawPointer *ptr, memory_order order);
void StoreRawPtr(const void* val, struct RawPointer *ptr, memory_order order);
void* SwapRawPtr(const void* val, struct RawPointer *ptr, memory_order order);
_Bool CASRawPtr(const void** current, const void* future, struct RawPointer *ptr, memory_order succ, memory_order fail);
_Bool WeakCASRawPtr(const void** current, const void* future, struct RawPointer *ptr, memory_order succ, memory_order fail);

// pointer-sized integer

struct AtomicWord
{
  volatile atomic_long a;
};

void InitWord(long val, struct AtomicWord *var);
long ReadWord(struct AtomicWord *var, memory_order order);
void StoreWord(long val, struct AtomicWord *var, memory_order order);
long SwapWord(long val, struct AtomicWord *var, memory_order order);
long AddWord(long increment, struct AtomicWord *var, memory_order order);
long SubWord(long increment, struct AtomicWord *var, memory_order order);
long OrWord(long bits, struct AtomicWord *var, memory_order order);
long XorWord(long bits, struct AtomicWord *var, memory_order order);
long AndWord(long bits, struct AtomicWord *var, memory_order order);
_Bool CASWord(long* current, long future, struct AtomicWord *var, memory_order succ, memory_order fail);
_Bool WeakCASWord(long* current, long future, struct AtomicWord *var, memory_order succ, memory_order fail);

// 32-bit integer

struct Atomic32
{
  volatile atomic_int a;
};

void Init32(int val, struct Atomic32 *var);
int Read32(struct Atomic32 *var, memory_order order);
void Store32(int val, struct Atomic32 *var, memory_order order);
int Swap32(int val, struct Atomic32 *var, memory_order order);
int Add32(int increment, struct Atomic32 *var, memory_order order);
int Sub32(int increment, struct Atomic32 *var, memory_order order);
int Or32(int bits, struct Atomic32 *var, memory_order order);
int Xor32(int bits, struct Atomic32 *var, memory_order order);
int And32(int bits, struct Atomic32 *var, memory_order order);
_Bool CAS32(int* current, int future, struct Atomic32 *var, memory_order succ, memory_order fail);
_Bool WeakCAS32(int* current, int future, struct Atomic32 *var, memory_order succ, memory_order fail);

// 64-bit integer

struct Atomic64
{
  volatile atomic_llong a;
};

void Init64(long long val, struct Atomic64 *var);
long long Read64(struct Atomic64 *var, memory_order order);
void Store64(long long val, struct Atomic64 *var, memory_order order);
long long Swap64(long long val, struct Atomic64 *var, memory_order order);
long long Add64(long long increment, struct Atomic64 *var, memory_order order);
long long Sub64(long long increment, struct Atomic64 *var, memory_order order);
long long Or64(long long bits, struct Atomic64 *var, memory_order order);
long long Xor64(long long bits, struct Atomic64 *var, memory_order order);
long long And64(long long bits, struct Atomic64 *var, memory_order order);
_Bool CAS64(long long* current, long long future, struct Atomic64 *var, memory_order succ, memory_order fail);
_Bool WeakCAS64(long long* current, long long future, struct Atomic64 *var, memory_order succ, memory_order fail);

// fence

void ThreadFence(memory_order order);

#endif
