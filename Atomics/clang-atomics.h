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

const void* ReadVoidPtr(void** var);
const void* SyncReadVoidPtr(void** var);
void StoreVoidPtr(const void* val, void** var);
void SyncStoreVoidPtr(const void* val, void** var);
const void* SwapVoidPtr(const void* val, void** var);
_Bool CASVoidPtr(void** current, const void* future, void** var);

// pointer-sized integer

long ReadWord(long *var, memory_order order);
void StoreWord(long val, long *var, memory_order order);
long SwapWord(long val, long* var, memory_order order);
long AddWord(long increment, long* var, memory_order order);
long SubWord(long increment, long* var, memory_order order);
long IncrementWord(long* var, memory_order order);
long DecrementWord(long* var, memory_order order);
long OrWord(long bits, long* var, memory_order order);
long XorWord(long bits, long* var, memory_order order);
long AndWord(long bits, long* var, memory_order order);
_Bool CASWord(long* current, long future, long* var, memory_order succ, memory_order fail);
_Bool CASWeakWord(long* current, long future, long* ptr, memory_order succ, memory_order fail);

// 32-bit integer

int Read32(int* var);
int SyncRead32(int* var);
void Store32(int val, int* var);
void SyncStore32(int val, int* var);
int Swap32(int val, int* var);
int Add32(int increment, int* var);
int Sub32(int increment, int* var);
int Increment32(int* var);
int Decrement32(int* var);
_Bool CAS32(int* current, int future, int* var);

// 64-bit integer

long long Read64(long long *var);
long long SyncRead64(long long *var);
void Store64(long long val, long long *var);
void SyncStore64(long long val, long long *var);
long long Swap64(long long val, long long *var);
long long Add64(long long increment, long long* var);
long long Sub64(long long increment, long long* var);
long long Increment64(long long* var);
long long Decrement64(long long* var);
_Bool CAS64(long long* current, long long future, long long* var);

#endif
