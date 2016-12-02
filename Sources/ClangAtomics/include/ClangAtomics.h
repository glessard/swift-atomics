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

void* ReadRawPtr(void** ptr, memory_order order);
void StoreRawPtr(const void* val, void** ptr, memory_order order);
void* SwapRawPtr(const void* val, void** ptr, memory_order order);
_Bool CASRawPtr(void** current, const void* future, void** ptr, memory_order succ, memory_order fail);
_Bool CASWeakRawPtr(void** current, const void* future, void** ptr, memory_order succ, memory_order fail);

// pointer-sized integer

long ReadWord(long *var, memory_order order);
void StoreWord(long val, long *var, memory_order order);
long SwapWord(long val, long* var, memory_order order);
long AddWord(long increment, long* var, memory_order order);
long SubWord(long increment, long* var, memory_order order);
long OrWord(long bits, long* var, memory_order order);
long XorWord(long bits, long* var, memory_order order);
long AndWord(long bits, long* var, memory_order order);
_Bool CASWord(long* current, long future, long* var, memory_order succ, memory_order fail);
_Bool CASWeakWord(long* current, long future, long* ptr, memory_order succ, memory_order fail);

// 32-bit integer

int Read32(int* var, memory_order order);
void Store32(int val, int* var, memory_order order);
int Swap32(int val, int* var, memory_order order);
int Add32(int increment, int* var, memory_order order);
int Sub32(int increment, int* var, memory_order order);
int Or32(int bits, int* var, memory_order order);
int Xor32(int bits, int* var, memory_order order);
int And32(int bits, int* var, memory_order order);
_Bool CAS32(int* current, int future, int* var, memory_order succ, memory_order fail);
_Bool CASWeak32(int* current, int future, int* ptr, memory_order succ, memory_order fail);

// 64-bit integer

long long Read64(long long *var, memory_order order);
long long SyncRead64(long long *var, memory_order order);
void Store64(long long val, long long *var, memory_order order);
void SyncStore64(long long val, long long *var, memory_order order);
long long Swap64(long long val, long long *var, memory_order order);
long long Add64(long long increment, long long* var, memory_order order);
long long Sub64(long long increment, long long* var, memory_order order);
long long Or64(long long bits, long long* var, memory_order order);
long long Xor64(long long bits, long long* var, memory_order order);
long long And64(long long bits, long long* var, memory_order order);
_Bool CAS64(long long* current, long long future, long long* var, memory_order succ, memory_order fail);
_Bool CASWeak64(long long* current, long long future, long long* ptr, memory_order succ, memory_order fail);

#endif
