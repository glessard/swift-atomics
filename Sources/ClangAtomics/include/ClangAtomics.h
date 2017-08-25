//
//  clang-atomics.h
//  Test23
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015 Guillaume Lessard. All rights reserved.
//

#ifndef clang_atomics_h
#define clang_atomics_h

#if !__has_feature(nullability)
#ifndef _Nullable
#define _Nullable
#endif
#ifndef _Nonnull
#define _Nonnull
#endif
#endif

#include <stdatomic.h>
#include <stdbool.h>
#include <assert.h>

// See: http://clang.llvm.org/doxygen/stdatomic_8h_source.html
//      http://clang.llvm.org/docs/LanguageExtensions.html#c11-atomic-builtins
//      http://en.cppreference.com/w/c/atomic
//      http://en.cppreference.com/w/c/atomic/atomic_compare_exchange

// memory order

#define SWIFT_ENUM(_name) enum _name

SWIFT_ENUM(MemoryOrder)
{
  MemoryOrder_relaxed =    __ATOMIC_RELAXED,
  // MemoryOrder_consume = __ATOMIC_CONSUME,
  MemoryOrder_acquire =    __ATOMIC_ACQUIRE,
  MemoryOrder_release =    __ATOMIC_RELEASE,
  MemoryOrder_acqrel  =    __ATOMIC_ACQ_REL,
  MemoryOrder_sequential = __ATOMIC_SEQ_CST
};

SWIFT_ENUM(LoadMemoryOrder)
{
  LoadMemoryOrder_relaxed =    __ATOMIC_RELAXED,
  // LoadMemoryOrder_consume = __ATOMIC_CONSUME,
  LoadMemoryOrder_acquire =    __ATOMIC_ACQUIRE,
  LoadMemoryOrder_sequential = __ATOMIC_SEQ_CST
};

SWIFT_ENUM(StoreMemoryOrder)
{
  StoreMemoryOrder_relaxed =    __ATOMIC_RELAXED,
  StoreMemoryOrder_release =    __ATOMIC_RELEASE,
  StoreMemoryOrder_sequential = __ATOMIC_SEQ_CST
};

// atomic integer generation

#define CLANG_ATOMICS_STRUCT(sType, aType) \
        typedef struct { volatile aType a; } sType;

#define CLANG_ATOMICS_INIT(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        void sType##Init(pType value, sType *_Nonnull ptr) \
        { atomic_init(&(ptr->a), value); }

#define CLANG_ATOMICS_LOAD(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        pType sType##Load(sType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { return atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_STORE(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        void sType##Store(pType value, sType *_Nonnull ptr, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), value, order); }

#define CLANG_ATOMICS_RMW(sType, pType, pName, op, opName) \
        static __inline__ __attribute__((__always_inline__)) \
        pType sType##opName(pType pName, sType *_Nonnull ptr, enum MemoryOrder order) \
        { return atomic_##op##_explicit(&(ptr->a), pName, order); }

#define CLANG_ATOMICS_CAS(sType, pType, strength, strName) \
        static __inline__ __attribute__((__always_inline__)) \
        _Bool sType##strName##CAS(pType *_Nonnull current, pType future, sType *_Nonnull ptr, \
                                  enum MemoryOrder succ, enum LoadMemoryOrder fail) \
        { \
          assert((unsigned int)fail <= (unsigned int)succ); \
          assert(succ == __ATOMIC_RELEASE ? fail == __ATOMIC_RELAXED : true); \
          return atomic_compare_exchange_##strength##_explicit(&(ptr->a), current, future, succ, fail); \
        }

#define CLANG_ATOMICS_GENERATE(sType, aType, pType) \
        CLANG_ATOMICS_STRUCT(sType, aType) \
        CLANG_ATOMICS_INIT(sType, pType) \
        CLANG_ATOMICS_LOAD(sType, pType) \
        CLANG_ATOMICS_STORE(sType, pType) \
        CLANG_ATOMICS_RMW(sType, pType, value, exchange, Swap) \
        CLANG_ATOMICS_RMW(sType, pType, increment, fetch_add, Add) \
        CLANG_ATOMICS_RMW(sType, pType, increment, fetch_sub, Sub) \
        CLANG_ATOMICS_RMW(sType, pType, bits, fetch_or, Or) \
        CLANG_ATOMICS_RMW(sType, pType, bits, fetch_xor, Xor) \
        CLANG_ATOMICS_RMW(sType, pType, bits, fetch_and, And) \
        CLANG_ATOMICS_CAS(sType, pType, strong, Strong) \
        CLANG_ATOMICS_CAS(sType, pType, weak, Weak)

// integer atomics

CLANG_ATOMICS_GENERATE(ClangAtomicsInt, atomic_long, long)
CLANG_ATOMICS_GENERATE(ClangAtomicsUInt, atomic_ulong, unsigned long)

CLANG_ATOMICS_GENERATE(ClangAtomicsInt8, atomic_schar, signed char)
CLANG_ATOMICS_GENERATE(ClangAtomicsUInt8, atomic_uchar, unsigned char)

CLANG_ATOMICS_GENERATE(ClangAtomicsInt16, atomic_short, short)
CLANG_ATOMICS_GENERATE(ClangAtomicsUInt16, atomic_ushort, unsigned short)

CLANG_ATOMICS_GENERATE(ClangAtomicsInt32, atomic_int, int)
CLANG_ATOMICS_GENERATE(ClangAtomicsUInt32, atomic_uint, unsigned int)

CLANG_ATOMICS_GENERATE(ClangAtomicsInt64, atomic_llong, long long)
CLANG_ATOMICS_GENERATE(ClangAtomicsUInt64, atomic_ullong, unsigned long long)

// bool atomics

CLANG_ATOMICS_STRUCT(ClangAtomicsBoolean, atomic_bool)
CLANG_ATOMICS_INIT(ClangAtomicsBoolean, _Bool)
CLANG_ATOMICS_LOAD(ClangAtomicsBoolean, _Bool)
CLANG_ATOMICS_STORE(ClangAtomicsBoolean, _Bool)
CLANG_ATOMICS_RMW(ClangAtomicsBoolean, _Bool, value, exchange, Swap)
CLANG_ATOMICS_RMW(ClangAtomicsBoolean, _Bool, value, fetch_or, Or)
CLANG_ATOMICS_RMW(ClangAtomicsBoolean, _Bool, value, fetch_xor, Xor)
CLANG_ATOMICS_RMW(ClangAtomicsBoolean, _Bool, value, fetch_and, And)
CLANG_ATOMICS_CAS(ClangAtomicsBoolean, _Bool, strong, Strong)
CLANG_ATOMICS_CAS(ClangAtomicsBoolean, _Bool, weak, Weak)

// pointer atomics

#define CLANG_ATOMICS_POINTER_INIT(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        void sType##Init(pType _Nullable value, sType *_Nonnull ptr) \
        { atomic_init(&(ptr->a), (uintptr_t)value); }

#define CLANG_ATOMICS_POINTER_LOAD(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        pType _Nullable sType##Load(sType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { return (pType) atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_POINTER_STORE(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        void sType##Store(pType _Nullable value, sType *_Nonnull ptr, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), (uintptr_t)value, order); }

#define CLANG_ATOMICS_POINTER_SWAP(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        pType _Nullable sType##Swap(pType _Nullable value, sType *_Nonnull ptr, enum MemoryOrder order) \
        { return (pType) atomic_exchange_explicit(&(ptr->a), (uintptr_t)value, order); }

#define CLANG_ATOMICS_POINTER_CAS(sType, pType, strength, strName) \
        static __inline__ __attribute__((__always_inline__)) \
        _Bool sType##strName##CAS(pType _Nullable* _Nonnull current, pType _Nullable future, sType *_Nonnull ptr, \
                                  enum MemoryOrder succ, enum LoadMemoryOrder fail) \
        { \
          assert((unsigned int)fail <= (unsigned int)succ); \
          assert(succ == __ATOMIC_RELEASE ? fail == __ATOMIC_RELAXED : true); \
          return atomic_compare_exchange_##strength##_explicit(&(ptr->a), (uintptr_t*)current, (uintptr_t)future, succ, fail); \
        }

CLANG_ATOMICS_STRUCT(ClangAtomicsMutablePointer, atomic_uintptr_t)
CLANG_ATOMICS_POINTER_INIT(ClangAtomicsMutablePointer, void*)
CLANG_ATOMICS_POINTER_LOAD(ClangAtomicsMutablePointer, void*)
CLANG_ATOMICS_POINTER_STORE(ClangAtomicsMutablePointer, void*)
CLANG_ATOMICS_POINTER_SWAP(ClangAtomicsMutablePointer, void*)
CLANG_ATOMICS_POINTER_CAS(ClangAtomicsMutablePointer, void*, strong, Strong)
CLANG_ATOMICS_POINTER_CAS(ClangAtomicsMutablePointer, void*, weak, Weak)

CLANG_ATOMICS_STRUCT(ClangAtomicsPointer, atomic_uintptr_t)
CLANG_ATOMICS_POINTER_INIT(ClangAtomicsPointer, const void*)
CLANG_ATOMICS_POINTER_LOAD(ClangAtomicsPointer, const void*)
CLANG_ATOMICS_POINTER_STORE(ClangAtomicsPointer, const void*)
CLANG_ATOMICS_POINTER_SWAP(ClangAtomicsPointer, const void*)
CLANG_ATOMICS_POINTER_CAS(ClangAtomicsPointer, const void*, strong, Strong)
CLANG_ATOMICS_POINTER_CAS(ClangAtomicsPointer, const void*, weak, Weak)

// fence

static __inline__ __attribute__((__always_inline__))
void ThreadFence(enum MemoryOrder order)
{
  atomic_thread_fence(order);
}

#endif
