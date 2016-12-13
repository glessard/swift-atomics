//
//  clang-atomics.m
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

#import "ClangAtomics.h"

// See: http://clang.llvm.org/doxygen/stdatomic_8h_source.html
//      http://clang.llvm.org/docs/LanguageExtensions.html#c11-atomic-builtins
//      http://en.cppreference.com/w/c/atomic
//      http://en.cppreference.com/w/c/atomic/atomic_compare_exchange

// pointer

void* ReadRawPtr(struct RawPointer* ptr, memory_order order)
{
  return atomic_load_explicit(&(ptr->a), order);
}

void StoreRawPtr(const void* val, struct RawPointer* ptr, memory_order order)
{
  atomic_store_explicit(&(ptr->a), (void*)val, order);
}

void* SwapRawPtr(const void* val, struct RawPointer* ptr, memory_order order)
{
  return atomic_exchange_explicit(&(ptr->a), (void*)val, order);
}

_Bool CASRawPtr(void** current, const void* future, struct RawPointer* ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_strong_explicit(&(ptr->a), (void**)current, (void*)future, succ, fail);
}

_Bool WeakCASRawPtr(void** current, const void* future, struct RawPointer* ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_weak_explicit(&(ptr->a), (void**)current, (void*)future, succ, fail);
}

// pointer-sized integer

long ReadWord(struct AtomicWord *ptr, memory_order order)
{
  return atomic_load_explicit(&(ptr->a), order);
}

void StoreWord(long val, struct AtomicWord *ptr, memory_order order)
{
  atomic_store_explicit(&(ptr->a), val, order);
}

long SwapWord(long val, struct AtomicWord *ptr, memory_order order)
{
  return atomic_exchange_explicit(&(ptr->a), val, order);
}

long AddWord(long increment, struct AtomicWord *ptr, memory_order order)
{
  return atomic_fetch_add_explicit(&(ptr->a), increment, order);
}

long SubWord(long increment, struct AtomicWord *ptr, memory_order order)
{
  return atomic_fetch_sub_explicit(&(ptr->a), increment, order);
}

long OrWord(long bits, struct AtomicWord *ptr, memory_order order)
{
  return atomic_fetch_or_explicit(&(ptr->a), bits, order);
}

long XorWord(long bits, struct AtomicWord *ptr, memory_order order)
{
  return atomic_fetch_xor_explicit(&(ptr->a), bits, order);
}

long AndWord(long bits, struct AtomicWord *ptr, memory_order order)
{
  return atomic_fetch_and_explicit(&(ptr->a), bits, order);
}

_Bool CASWord(long* current, long future, struct AtomicWord *ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_strong_explicit(&(ptr->a), current, future, succ, fail);
}

_Bool WeakCASWord(long* current, long future, struct AtomicWord *ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_weak_explicit(&(ptr->a), current, future, succ, fail);
}

// 32-bit integer

int Read32(struct Atomic32 *ptr, memory_order order)
{
  return atomic_load_explicit(&(ptr->a), order);
}

void Store32(int val, struct Atomic32 *ptr, memory_order order)
{
  atomic_store_explicit(&(ptr->a), val, order);
}

int Swap32(int val, struct Atomic32 *ptr, memory_order order)
{
  return atomic_exchange_explicit(&(ptr->a), val, order);
}

int Add32(int increment, struct Atomic32 *ptr, memory_order order)
{
  return atomic_fetch_add_explicit(&(ptr->a), increment, order);
}

int Sub32(int increment, struct Atomic32 *ptr, memory_order order)
{
  return atomic_fetch_sub_explicit(&(ptr->a), increment, order);
}

int Or32(int bits, struct Atomic32 *ptr, memory_order order)
{
  return atomic_fetch_or_explicit(&(ptr->a), bits, order);
}

int Xor32(int bits, struct Atomic32 *ptr, memory_order order)
{
  return atomic_fetch_xor_explicit(&(ptr->a), bits, order);
}

int And32(int bits, struct Atomic32 *ptr, memory_order order)
{
  return atomic_fetch_and_explicit(&(ptr->a), bits, order);
}

_Bool CAS32(int* current, int future, struct Atomic32 *ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_strong_explicit(&(ptr->a), current, future, succ, fail);
}

_Bool WeakCAS32(int* current, int future, struct Atomic32 *ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_weak_explicit(&(ptr->a), current, future, succ, fail);
}

// 64-bit integer

long long Read64(struct Atomic64 *ptr, memory_order order)
{
  return atomic_load_explicit(&(ptr->a), order);
}

void Store64(long long val, struct Atomic64 *ptr, memory_order order)
{
  atomic_store_explicit(&(ptr->a), val, order);
}

long long Swap64(long long val, struct Atomic64 *ptr, memory_order order)
{
  return atomic_exchange_explicit(&(ptr->a), val, order);
}

long long Add64(long long increment, struct Atomic64 *ptr, memory_order order)
{
  return atomic_fetch_add_explicit(&(ptr->a), increment, order);
}

long long Sub64(long long increment, struct Atomic64 *ptr, memory_order order)
{
  return atomic_fetch_sub_explicit(&(ptr->a), increment, order);
}

long long Or64(long long bits, struct Atomic64 *ptr, memory_order order)
{
  return atomic_fetch_or_explicit(&(ptr->a), bits, order);
}

long long Xor64(long long bits, struct Atomic64 *ptr, memory_order order)
{
  return atomic_fetch_xor_explicit(&(ptr->a), bits, order);
}

long long And64(long long bits, struct Atomic64 *ptr, memory_order order)
{
  return atomic_fetch_and_explicit(&(ptr->a), bits, order);
}

_Bool CAS64(long long* current, long long future, struct Atomic64 *ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_strong_explicit(&(ptr->a), current, future, succ, fail);
}

_Bool WeakCAS64(long long* current, long long future, struct Atomic64 *ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_weak_explicit(&(ptr->a), current, future, succ, fail);
}
