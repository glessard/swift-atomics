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

// pointer-sized integer

long ReadLong(long *var);
long SyncReadLong(long *var);
void StoreLong(long val, long *var);
void SyncStoreLong(long val, long *var);
long SwapLong(long val, long* var);
long AddLong(long increment, long* var);
long SubLong(long increment, long* var);
long IncrementLong(long* var);
long DecrementLong(long* var);

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

#endif
