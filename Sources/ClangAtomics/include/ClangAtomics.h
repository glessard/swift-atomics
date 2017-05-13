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

// See: http://clang.llvm.org/doxygen/stdatomic_8h_source.html
//      http://clang.llvm.org/docs/LanguageExtensions.html#c11-atomic-builtins
//      http://en.cppreference.com/w/c/atomic
//      http://en.cppreference.com/w/c/atomic/atomic_compare_exchange

// memory order

typedef enum
{
  clang_atomics_memory_order_relaxed = __ATOMIC_RELAXED,
//clang_atomics_memory_order_consume = __ATOMIC_CONSUME,
  clang_atomics_memory_order_acquire = __ATOMIC_ACQUIRE,
  clang_atomics_memory_order_release = __ATOMIC_RELEASE,
  clang_atomics_memory_order_acq_rel = __ATOMIC_ACQ_REL,
  clang_atomics_memory_order_seq_cst = __ATOMIC_SEQ_CST
} MemoryOrder;

typedef enum
{
  clang_atomics_load_memory_order_relaxed = __ATOMIC_RELAXED,
//clang_atomics_load_memory_order_consume = __ATOMIC_CONSUME,
  clang_atomics_load_memory_order_acquire = __ATOMIC_ACQUIRE,
  clang_atomics_load_memory_order_seq_cst = __ATOMIC_SEQ_CST
} LoadMemoryOrder;

typedef enum
{
  clang_atomics_store_memory_order_relaxed = __ATOMIC_RELAXED,
  clang_atomics_store_memory_order_release = __ATOMIC_RELEASE,
  clang_atomics_store_memory_order_seq_cst = __ATOMIC_SEQ_CST
} StoreMemoryOrder;

// pointer

typedef struct
{
  volatile atomic_uintptr_t a;
} AtomicVoidPointer;

static __inline__ __attribute__((__always_inline__))
void AtomicPointerInit(const void* _Nullable val, AtomicVoidPointer* _Nonnull ptr)
{
  atomic_init(&(ptr->a), (uintptr_t)val);
}

static __inline__ __attribute__((__always_inline__))
void* _Nullable AtomicPointerLoad(AtomicVoidPointer* _Nonnull ptr, LoadMemoryOrder order)
{
  return (void*) atomic_load_explicit(&(ptr->a), order);
}

static __inline__ __attribute__((__always_inline__))
void AtomicPointerStore(const void* _Nullable val, AtomicVoidPointer* _Nonnull ptr, StoreMemoryOrder order)
{
  atomic_store_explicit(&(ptr->a), (uintptr_t)val, order);
}

static __inline__ __attribute__((__always_inline__))
void* _Nullable AtomicPointerSwap(const void* _Nullable val, AtomicVoidPointer* _Nonnull ptr, MemoryOrder order)
{
  return (void*) atomic_exchange_explicit(&(ptr->a), (uintptr_t)val, order);
}

static __inline__ __attribute__((__always_inline__))
_Bool AtomicPointerStrongCAS(const void* _Nullable* _Nonnull current, const void* _Nullable future, AtomicVoidPointer* _Nonnull ptr,
                             MemoryOrder succ, LoadMemoryOrder fail)
{
  return atomic_compare_exchange_strong_explicit(&(ptr->a), (uintptr_t*)current, (uintptr_t)future, succ, fail);
}

static __inline__ __attribute__((__always_inline__))
_Bool AtomicPointerWeakCAS(const void* _Nullable* _Nonnull current, const void* _Nullable future, AtomicVoidPointer* _Nonnull ptr,
                           MemoryOrder succ, LoadMemoryOrder fail)
{
  return atomic_compare_exchange_weak_explicit(&(ptr->a), (uintptr_t*)current, (uintptr_t)future, succ, fail);
}

// integer atomics generation

#define CLANG_ATOMICS_STRUCT(sType, aType) \
        typedef struct { volatile aType a; } sType;

#define CLANG_ATOMICS_INIT(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        void sType##Init(pType value, sType *_Nonnull ptr) \
        { atomic_init(&(ptr->a), value); }

#define CLANG_ATOMICS_LOAD(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        pType sType##Load(sType *_Nonnull ptr, LoadMemoryOrder order) \
        { return atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_STORE(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        void sType##Store(pType value, sType *_Nonnull ptr, StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), value, order); }

#define CLANG_ATOMICS_RMW(sType, pType, pName, op, opName) \
        static __inline__ __attribute__((__always_inline__)) \
        pType sType##opName(pType pName, sType *_Nonnull ptr, MemoryOrder order) \
        { return atomic_##op##_explicit(&(ptr->a), pName, order); }

#define CLANG_ATOMICS_CAS(sType, pType, strength, strName) \
        static __inline__ __attribute__((__always_inline__)) \
        _Bool sType##strName##CAS(pType *_Nonnull current, pType future, sType *_Nonnull ptr, \
                                  MemoryOrder succ, LoadMemoryOrder fail) \
        { return atomic_compare_exchange_##strength##_explicit(&(ptr->a), current, future, succ, fail); }

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

CLANG_ATOMICS_GENERATE(AtomicWord, atomic_long, long)

CLANG_ATOMICS_GENERATE(Atomic8, atomic_char, char)

CLANG_ATOMICS_GENERATE(Atomic32, atomic_int, int)

CLANG_ATOMICS_GENERATE(Atomic64, atomic_llong, long long)

// bool atomics

CLANG_ATOMICS_STRUCT(AtomicBoolean, atomic_bool)
CLANG_ATOMICS_INIT(AtomicBoolean, _Bool)
CLANG_ATOMICS_LOAD(AtomicBoolean, _Bool)
CLANG_ATOMICS_STORE(AtomicBoolean, _Bool)
CLANG_ATOMICS_RMW(AtomicBoolean, _Bool, value, exchange, Swap)
CLANG_ATOMICS_RMW(AtomicBoolean, _Bool, value, fetch_or, Or)
CLANG_ATOMICS_RMW(AtomicBoolean, _Bool, value, fetch_xor, Xor)
CLANG_ATOMICS_RMW(AtomicBoolean, _Bool, value, fetch_and, And)
CLANG_ATOMICS_CAS(AtomicBoolean, _Bool, strong, Strong)
CLANG_ATOMICS_CAS(AtomicBoolean, _Bool, weak, Weak)

// fence

static __inline__ __attribute__((__always_inline__))
void ThreadFence(MemoryOrder order)
{
  atomic_thread_fence(order);
}

#endif
