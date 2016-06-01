//
//  clang-atomics.m
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

#import "clang-atomics.h"

// See: http://clang.llvm.org/doxygen/stdatomic_8h_source.html
//      http://clang.llvm.org/docs/LanguageExtensions.html#c11-atomic-builtins
//      http://en.cppreference.com/w/c/atomic
//      http://en.cppreference.com/w/c/atomic/atomic_compare_exchange

// pointer

const void* ReadVoidPtr(void** ptr)
{
  return atomic_load_explicit((_Atomic(void*)*)ptr, __ATOMIC_RELAXED);
}

const void* SyncReadVoidPtr(void** ptr)
{
  return atomic_load_explicit((_Atomic(void*)*)ptr, __ATOMIC_SEQ_CST);
}

void StoreVoidPtr(const void* val, void** ptr)
{
  atomic_store_explicit((_Atomic(void*)*)ptr, (void*)val, __ATOMIC_RELAXED);
}

void SyncStoreVoidPtr(const void* val, void** ptr)
{
  atomic_store_explicit((_Atomic(void*)*)ptr, (void*)val, __ATOMIC_SEQ_CST);
}

const void* SwapVoidPtr(const void* val, void** ptr)
{
  return atomic_exchange_explicit((_Atomic(void*)*)ptr, (void*)val, __ATOMIC_SEQ_CST);
}

_Bool CASVoidPtr(void** current, const void* future, void** ptr)
{
  return atomic_compare_exchange_weak_explicit((_Atomic(void*)*)ptr, (void**)current, (void*)future, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED);
}

// pointer-sized integer

long ReadWord(long *ptr, memory_order order)
{
  return atomic_load_explicit((_Atomic(long)*)ptr, order);
}

void StoreWord(long val, long* ptr, memory_order order)
{
  atomic_store_explicit((_Atomic(long)*)ptr, val, order);
}

long SwapWord(long val, long *ptr, memory_order order)
{
  return atomic_exchange_explicit((_Atomic(long)*)ptr, val, order);
}

long AddWord(long increment, long* ptr, memory_order order)
{
  return atomic_fetch_add_explicit((_Atomic(long)*)ptr, increment, order);
}

long SubWord(long increment, long* ptr, memory_order order)
{
  return atomic_fetch_sub_explicit((_Atomic(long)*)ptr, increment, order);
}

long IncrementWord(long* ptr, memory_order order)
{
  return atomic_fetch_add_explicit((_Atomic(long)*)ptr, 1, order);
}

long DecrementWord(long* ptr, memory_order order)
{
  return atomic_fetch_sub_explicit((_Atomic(long)*)ptr, 1, order);
}

long OrWord(long bits, long* ptr, memory_order order)
{
  return atomic_fetch_or_explicit((_Atomic(long)*)ptr, bits, order);
}

long XorWord(long bits, long* ptr, memory_order order)
{
  return atomic_fetch_xor_explicit((_Atomic(long)*)ptr, bits, order);
}

long AndWord(long bits, long* ptr, memory_order order)
{
  return atomic_fetch_and_explicit((_Atomic(long)*)ptr, bits, order);
}

_Bool CASWord(long* current, long future, long* ptr, memory_order succ, memory_order fail)
{
  return atomic_compare_exchange_weak_explicit((_Atomic(long)*)ptr, current, future, succ, fail);
}

// 32-bit integer

int Read32(int *ptr)
{
  return atomic_load_explicit((_Atomic(int)*)ptr, __ATOMIC_RELAXED);
}

int SyncRead32(int *ptr)
{
  return atomic_load_explicit((_Atomic(int)*)ptr, __ATOMIC_SEQ_CST);
}

void Store32(int val, int* ptr)
{
  atomic_store_explicit((_Atomic(int)*)ptr, val, __ATOMIC_RELAXED);
}

void SyncStore32(int val, int* ptr)
{
  atomic_store_explicit((_Atomic(int)*)ptr, val, __ATOMIC_SEQ_CST);
}

int Swap32(int val, int *ptr)
{
  return atomic_exchange_explicit((_Atomic(int)*)ptr, val, __ATOMIC_SEQ_CST);
}

int Add32(int increment, int* ptr)
{
  return atomic_fetch_add_explicit((_Atomic(int)*)ptr, increment, __ATOMIC_SEQ_CST);
}

int Sub32(int increment, int* ptr)
{
  return atomic_fetch_sub_explicit((_Atomic(int)*)ptr, increment, __ATOMIC_SEQ_CST);
}

int Increment32(int* ptr)
{
  return atomic_fetch_add_explicit((_Atomic(int)*)ptr, 1, __ATOMIC_SEQ_CST);
}

int Decrement32(int* ptr)
{
  return atomic_fetch_sub_explicit((_Atomic(int)*)ptr, 1, __ATOMIC_SEQ_CST);
}

_Bool CAS32(int* current, int future, int* ptr)
{
  return atomic_compare_exchange_weak_explicit((_Atomic(int)*)ptr, current, future, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED);
}

// 64-bit integer

long long Read64(long long *ptr)
{
  return atomic_load_explicit((_Atomic(long long)*)ptr, __ATOMIC_RELAXED);
}

long long SyncRead64(long long *ptr)
{
  return atomic_load_explicit((_Atomic(long long)*)ptr, __ATOMIC_SEQ_CST);
}

void Store64(long long val, long long* ptr)
{
  atomic_store_explicit((_Atomic(long long)*)ptr, val, __ATOMIC_RELAXED);
}

void SyncStore64(long long val, long long* ptr)
{
  atomic_store_explicit((_Atomic(long long)*)ptr, val, __ATOMIC_SEQ_CST);
}

long long Swap64(long long val, long long *ptr)
{
  return  atomic_exchange_explicit((_Atomic(long long)*)ptr, val, __ATOMIC_SEQ_CST);
}

long long Add64(long long increment, long long* ptr)
{
  return atomic_fetch_add_explicit((_Atomic(long long)*)ptr, increment, __ATOMIC_SEQ_CST);
}

long long Sub64(long long increment, long long* ptr)
{
  return atomic_fetch_sub_explicit((_Atomic(long long)*)ptr, increment, __ATOMIC_SEQ_CST);
}

long long Increment64(long long* ptr)
{
  return atomic_fetch_add_explicit((_Atomic(long long)*)ptr, 1, __ATOMIC_SEQ_CST);
}

long long Decrement64(long long* ptr)
{
  return atomic_fetch_sub_explicit((_Atomic(long long)*)ptr, 1, __ATOMIC_SEQ_CST);
}

_Bool CAS64(long long* current, long long future, long long* ptr)
{
  return atomic_compare_exchange_weak_explicit((_Atomic(long long)*)ptr, current, future, __ATOMIC_SEQ_CST, __ATOMIC_RELAXED);
}
