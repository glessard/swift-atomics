//
//  clang-atomics.h
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

#ifndef clang_atomics_h
#define clang_atomics_h

// Pointer

const void* ReadVoidPtr(void** var);
const void* SyncReadVoidPtr(void** var);
void StoreVoidPtr(const void* val, void** var);
void SyncStoreVoidPtr(const void* val, void** var);
const void* SwapVoidPtr(const void* val, void** var);
_Bool CASVoidPtr(void** current, const void* future, void** var);

// pointer-sized integer

long ReadWord(long *var);
long SyncReadWord(long *var);
void StoreWord(long val, long *var);
void SyncStoreWord(long val, long *var);
long SwapWord(long val, long* var);
long AddWord(long increment, long* var);
long SubWord(long increment, long* var);
long IncrementWord(long* var);
long DecrementWord(long* var);
_Bool CASWord(long* current, long future, long* var);

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
