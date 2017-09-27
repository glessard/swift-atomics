//
//  CAtomics.h
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015-2017 Guillaume Lessard. All rights reserved.
//  This file is distributed under the BSD 3-clause license. See LICENSE for details.
//
// See: http://clang.llvm.org/doxygen/stdatomic_8h_source.html
//      http://clang.llvm.org/docs/LanguageExtensions.html#c11-atomic-builtins
//      http://en.cppreference.com/w/c/atomic
//      http://en.cppreference.com/w/c/atomic/atomic_compare_exchange

#ifndef c_atomics_h
#define c_atomics_h

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

#if __has_attribute(enum_extensibility)
#define SWIFT_ENUM(_name,extensibility) enum __attribute__((enum_extensibility(extensibility))) _name
#else
#define SWIFT_ENUM(_name,extensibility) enum _name
#endif

// memory order

SWIFT_ENUM(MemoryOrder, open)
{
  MemoryOrder_relaxed =    __ATOMIC_RELAXED,
  // MemoryOrder_consume = __ATOMIC_CONSUME,
  MemoryOrder_acquire =    __ATOMIC_ACQUIRE,
  MemoryOrder_release =    __ATOMIC_RELEASE,
  MemoryOrder_acqrel  =    __ATOMIC_ACQ_REL,
  MemoryOrder_sequential = __ATOMIC_SEQ_CST
};

SWIFT_ENUM(LoadMemoryOrder, open)
{
  LoadMemoryOrder_relaxed =    __ATOMIC_RELAXED,
  // LoadMemoryOrder_consume = __ATOMIC_CONSUME,
  LoadMemoryOrder_acquire =    __ATOMIC_ACQUIRE,
  LoadMemoryOrder_sequential = __ATOMIC_SEQ_CST
};

SWIFT_ENUM(StoreMemoryOrder, open)
{
  StoreMemoryOrder_relaxed =    __ATOMIC_RELAXED,
  StoreMemoryOrder_release =    __ATOMIC_RELEASE,
  StoreMemoryOrder_sequential = __ATOMIC_SEQ_CST
};

// form of compare-and-swap operation

#define __ATOMIC_CAS_TYPE_STRONG 0
#define __ATOMIC_CAS_TYPE_WEAK   1

SWIFT_ENUM(CASType, closed)
{
  CASType_strong = __ATOMIC_CAS_TYPE_STRONG,
  CASType_weak =   __ATOMIC_CAS_TYPE_WEAK
};

#if __has_attribute(swift_name)
# define SWIFT_NAME(_name) __attribute__((swift_name(#_name)))
#else
# define SWIFT_NAME(_name)
#endif

// atomic integer generation

#define CLANG_ATOMICS_STRUCT(sType, aType) \
        typedef struct { volatile aType a; } sType;

#define CLANG_ATOMICS_INIT(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.initialize(self:_:)) \
        void sType##Init(sType *_Nonnull ptr, pType value) \
        { atomic_init(&(ptr->a), value); }

#define CLANG_ATOMICS_LOAD(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.load(self:_:)) \
        pType sType##Load(sType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { return atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_STORE(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.store(self:_:_:)) \
        void sType##Store(sType *_Nonnull ptr, pType value, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), value, order); }

#define CLANG_ATOMICS_SWAP(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.swap(self:_:_:)) \
        pType sType##Swap(sType *_Nonnull ptr, pType value, enum MemoryOrder order) \
        { return atomic_exchange_explicit(&(ptr->a), value, order); }

#define CLANG_ATOMICS_RMW(sType, pType, pName, op, opName) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.op(self:_:_:)) \
        pType sType##opName(sType *_Nonnull ptr, pType pName, enum MemoryOrder order) \
        { return atomic_##op##_explicit(&(ptr->a), pName, order); }

#define CLANG_ATOMICS_CAS(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.loadCAS(self:_:_:_:_:_:)) \
        _Bool sType##LoadCAS(sType *_Nonnull ptr, pType *_Nonnull current, pType future, \
                             enum CASType type, enum MemoryOrder orderSwap, enum LoadMemoryOrder orderLoad) \
        { \
          assert((unsigned int)orderLoad <= (unsigned int)orderSwap); \
          assert(orderSwap == __ATOMIC_RELEASE ? orderLoad == __ATOMIC_RELAXED : true); \
          if(type == __ATOMIC_CAS_TYPE_STRONG) \
            return atomic_compare_exchange_strong_explicit(&(ptr->a), current, future, orderSwap, orderLoad); \
          else \
            return atomic_compare_exchange_weak_explicit(&(ptr->a), current, future, orderSwap, orderLoad); \
        } \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.CAS(self:_:_:_:_:)) \
        _Bool sType##CAS(sType *_Nonnull ptr, pType current, pType future, \
                         enum CASType type, enum MemoryOrder order) \
        { \
          pType expect = current; \
          return sType##LoadCAS(ptr, &expect, future, type, order, LoadMemoryOrder_relaxed); \
        }

#define CLANG_ATOMICS_GENERATE(sType, aType, pType) \
        CLANG_ATOMICS_STRUCT(sType, aType) \
        CLANG_ATOMICS_INIT(sType, pType) \
        CLANG_ATOMICS_LOAD(sType, pType) \
        CLANG_ATOMICS_STORE(sType, pType) \
        CLANG_ATOMICS_SWAP(sType, pType) \
        CLANG_ATOMICS_RMW(sType, pType, increment, fetch_add, Add) \
        CLANG_ATOMICS_RMW(sType, pType, increment, fetch_sub, Sub) \
        CLANG_ATOMICS_RMW(sType, pType, bits, fetch_or, Or) \
        CLANG_ATOMICS_RMW(sType, pType, bits, fetch_xor, Xor) \
        CLANG_ATOMICS_RMW(sType, pType, bits, fetch_and, And) \
        CLANG_ATOMICS_CAS(sType, pType)

// integer atomics

CLANG_ATOMICS_GENERATE(AtomicInt, atomic_long, long)
CLANG_ATOMICS_GENERATE(AtomicUInt, atomic_ulong, unsigned long)

CLANG_ATOMICS_GENERATE(AtomicInt8, atomic_schar, signed char)
CLANG_ATOMICS_GENERATE(AtomicUInt8, atomic_uchar, unsigned char)

CLANG_ATOMICS_GENERATE(AtomicInt16, atomic_short, short)
CLANG_ATOMICS_GENERATE(AtomicUInt16, atomic_ushort, unsigned short)

CLANG_ATOMICS_GENERATE(AtomicInt32, atomic_int, int)
CLANG_ATOMICS_GENERATE(AtomicUInt32, atomic_uint, unsigned int)

CLANG_ATOMICS_GENERATE(AtomicInt64, atomic_llong, long long)
CLANG_ATOMICS_GENERATE(AtomicUInt64, atomic_ullong, unsigned long long)

// bool atomics

CLANG_ATOMICS_STRUCT(AtomicBool, atomic_bool)
CLANG_ATOMICS_INIT(AtomicBool, _Bool)
CLANG_ATOMICS_LOAD(AtomicBool, _Bool)
CLANG_ATOMICS_STORE(AtomicBool, _Bool)
CLANG_ATOMICS_SWAP(AtomicBool, _Bool)
CLANG_ATOMICS_RMW(AtomicBool, _Bool, value, fetch_or, Or)
CLANG_ATOMICS_RMW(AtomicBool, _Bool, value, fetch_xor, Xor)
CLANG_ATOMICS_RMW(AtomicBool, _Bool, value, fetch_and, And)
CLANG_ATOMICS_CAS(AtomicBool, _Bool)

// pointer atomics

#define CLANG_ATOMICS_POINTER_INIT(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.initialize(self:_:)) \
        void sType##Init(sType *_Nonnull ptr, pType _Nullable value) \
        { atomic_init(&(ptr->a), (uintptr_t)value); }

#define CLANG_ATOMICS_POINTER_LOAD(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.load(self:_:)) \
        pType _Nullable sType##Load(sType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { return (pType) atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_POINTER_STORE(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.store(self:_:_:)) \
        void sType##Store(sType *_Nonnull ptr, pType _Nullable value, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), (uintptr_t)value, order); }

#define CLANG_ATOMICS_POINTER_SWAP(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.swap(self:_:_:)) \
        pType _Nullable sType##Swap(sType *_Nonnull ptr, pType _Nullable value, enum MemoryOrder order) \
        { return (pType) atomic_exchange_explicit(&(ptr->a), (uintptr_t)value, order); }

#define CLANG_ATOMICS_POINTER_CAS(sType, pType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.loadCAS(self:_:_:_:_:_:)) \
        _Bool sType##LoadCAS(sType *_Nonnull ptr, pType _Nullable* _Nonnull current, pType _Nullable future, \
                             enum CASType type, enum MemoryOrder orderSwap, enum LoadMemoryOrder orderLoad) \
        { \
          assert((unsigned int)orderLoad <= (unsigned int)orderSwap); \
          assert(orderSwap == __ATOMIC_RELEASE ? orderLoad == __ATOMIC_RELAXED : true); \
          if(type == __ATOMIC_CAS_TYPE_STRONG) \
            return atomic_compare_exchange_strong_explicit(&(ptr->a), (uintptr_t*)current, (uintptr_t)future, orderSwap, orderLoad); \
          else \
            return atomic_compare_exchange_weak_explicit(&(ptr->a), (uintptr_t*)current, (uintptr_t)future, orderSwap, orderLoad); \
        } \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(sType.CAS(self:_:_:_:_:)) \
        _Bool sType##CAS(sType *_Nonnull ptr, pType _Nullable current, pType _Nullable future, \
                         enum CASType type, enum MemoryOrder order) \
        { \
          pType expect = current; \
          return sType##LoadCAS(ptr, &expect, future, type, order, LoadMemoryOrder_relaxed); \
        }

CLANG_ATOMICS_STRUCT(AtomicMutableRawPointer, atomic_uintptr_t)
CLANG_ATOMICS_POINTER_INIT(AtomicMutableRawPointer, void*)
CLANG_ATOMICS_POINTER_LOAD(AtomicMutableRawPointer, void*)
CLANG_ATOMICS_POINTER_STORE(AtomicMutableRawPointer, void*)
CLANG_ATOMICS_POINTER_SWAP(AtomicMutableRawPointer, void*)
CLANG_ATOMICS_POINTER_CAS(AtomicMutableRawPointer, void*)

CLANG_ATOMICS_STRUCT(AtomicRawPointer, atomic_uintptr_t)
CLANG_ATOMICS_POINTER_INIT(AtomicRawPointer, const void*)
CLANG_ATOMICS_POINTER_LOAD(AtomicRawPointer, const void*)
CLANG_ATOMICS_POINTER_STORE(AtomicRawPointer, const void*)
CLANG_ATOMICS_POINTER_SWAP(AtomicRawPointer, const void*)
CLANG_ATOMICS_POINTER_CAS(AtomicRawPointer, const void*)

struct opaque;

CLANG_ATOMICS_STRUCT(AtomicOpaquePointer, atomic_uintptr_t)
CLANG_ATOMICS_POINTER_INIT(AtomicOpaquePointer, struct opaque*)
CLANG_ATOMICS_POINTER_LOAD(AtomicOpaquePointer, struct opaque*)
CLANG_ATOMICS_POINTER_STORE(AtomicOpaquePointer, struct opaque*)
CLANG_ATOMICS_POINTER_SWAP(AtomicOpaquePointer, struct opaque*)
CLANG_ATOMICS_POINTER_CAS(AtomicOpaquePointer, struct opaque*)

// fence

static __inline__ __attribute__((__always_inline__))
void CAtomicsThreadFence(enum MemoryOrder order)
{
  atomic_thread_fence(order);
}

#endif
