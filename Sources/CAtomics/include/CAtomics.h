//
//  CAtomics.h
//
//  Created by Guillaume Lessard on 2015-05-21.
//  Copyright (c) 2015-2018 Guillaume Lessard. All rights reserved.
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

#ifdef __SSE2__
#include <immintrin.h>
#else
#include <sched.h>
#endif

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

#if defined(__x86_64__)
#define __CACHE_LINE_WIDTH 64
#elif defined(__arm64__)
#define __CACHE_LINE_WIDTH 64
#elif defined(__arm__)
#define __CACHE_LINE_WIDTH 64
#elif defined(__i386__)
#define __CACHE_LINE_WIDTH 64
#else
// define __CACHE_LINE_WIDTH appropriately as needed
#endif

#if !defined(__x86_64__) && !defined(__arm64__)
#define __has32bitPointer__
#endif

// atomic integer generation

#define CLANG_ATOMICS_STRUCT(swiftType, atomicType, alignment) \
        typedef struct { volatile atomicType a __attribute__ ((aligned(alignment))); } swiftType;

#define CLANG_ATOMICS_IS_LOCK_FREE(swiftType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.isLockFree(self:)) \
        _Bool swiftType##IsLockFree(swiftType *_Nonnull ptr) \
        { return atomic_is_lock_free(&(ptr->a)); }

#define CLANG_ATOMICS_INITIALIZE(swiftType, parameterType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.initialize(self:_:)) \
        void swiftType##Initialize(swiftType *_Nonnull ptr, parameterType value) \
        { atomic_init(&(ptr->a), value); }

#define CLANG_ATOMICS_CREATE(swiftType, parameterType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.init(_:)) \
        swiftType swiftType##Create(parameterType value) \
        { swiftType s; swiftType##Initialize(&s, value); return s; }

#define CLANG_ATOMICS_LOAD(swiftType, parameterType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.load(self:_:)) \
        parameterType swiftType##Load(swiftType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { return atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_STORE(swiftType, parameterType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.store(self:_:_:)) \
        void swiftType##Store(swiftType *_Nonnull ptr, parameterType value, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), value, order); }

#define CLANG_ATOMICS_SWAP(swiftType, parameterType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.swap(self:_:_:)) \
        parameterType swiftType##Swap(swiftType *_Nonnull ptr, parameterType value, enum MemoryOrder order) \
        { return atomic_exchange_explicit(&(ptr->a), value, order); }

#define CLANG_ATOMICS_RMW(swiftType, parameterType, pName, op, opName) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.op(self:_:_:)) \
        parameterType swiftType##opName(swiftType *_Nonnull ptr, parameterType pName, enum MemoryOrder order) \
        { return atomic_##op##_explicit(&(ptr->a), pName, order); }

#define CLANG_ATOMICS_CAS(swiftType, parameterType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.loadCAS(self:_:_:_:_:_:)) \
        _Bool swiftType##LoadCAS(swiftType *_Nonnull ptr, parameterType *_Nonnull current, parameterType future, \
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
        SWIFT_NAME(swiftType.CAS(self:_:_:_:_:)) \
        _Bool swiftType##CAS(swiftType *_Nonnull ptr, parameterType current, parameterType future, \
                             enum CASType type, enum MemoryOrder order) \
        { \
          parameterType expect = current; \
          return swiftType##LoadCAS(ptr, &expect, future, type, order, LoadMemoryOrder_relaxed); \
        }

#define CLANG_ATOMICS_GENERATE(swiftType, atomicType, parameterType, alignment) \
        CLANG_ATOMICS_STRUCT(swiftType, atomicType, alignment) \
        CLANG_ATOMICS_IS_LOCK_FREE(swiftType) \
        CLANG_ATOMICS_INITIALIZE(swiftType, parameterType) \
        CLANG_ATOMICS_CREATE(swiftType, parameterType) \
        CLANG_ATOMICS_LOAD(swiftType, parameterType) \
        CLANG_ATOMICS_STORE(swiftType, parameterType) \
        CLANG_ATOMICS_SWAP(swiftType, parameterType) \
        CLANG_ATOMICS_CAS(swiftType, parameterType)

#define CLANG_ATOMICS_INT_GENERATE(swiftType, atomicType, parameterType, alignment) \
        CLANG_ATOMICS_GENERATE(swiftType, atomicType, parameterType, alignment) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, increment, fetch_add, Add) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, increment, fetch_sub, Sub) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, bits, fetch_or, Or) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, bits, fetch_xor, Xor) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, bits, fetch_and, And)

// integer atomics

CLANG_ATOMICS_INT_GENERATE(AtomicInt, atomic_intptr_t, intptr_t, _Alignof(atomic_intptr_t))
CLANG_ATOMICS_INT_GENERATE(AtomicUInt, atomic_uintptr_t, uintptr_t, _Alignof(atomic_uintptr_t))

CLANG_ATOMICS_INT_GENERATE(AtomicInt8, atomic_schar, signed char, _Alignof(atomic_schar))
CLANG_ATOMICS_INT_GENERATE(AtomicUInt8, atomic_uchar, unsigned char, _Alignof(atomic_uchar))

CLANG_ATOMICS_INT_GENERATE(AtomicInt16, atomic_short, short, _Alignof(atomic_short))
CLANG_ATOMICS_INT_GENERATE(AtomicUInt16, atomic_ushort, unsigned short, _Alignof(atomic_ushort))

CLANG_ATOMICS_INT_GENERATE(AtomicInt32, atomic_int, int, _Alignof(atomic_int))
CLANG_ATOMICS_INT_GENERATE(AtomicUInt32, atomic_uint, unsigned int, _Alignof(atomic_uint))

CLANG_ATOMICS_INT_GENERATE(AtomicInt64, atomic_llong, long long, _Alignof(atomic_llong))
CLANG_ATOMICS_INT_GENERATE(AtomicUInt64, atomic_ullong, unsigned long long, _Alignof(atomic_ullong))

// bool atomics

#define CLANG_ATOMICS_BOOL_GENERATE(swiftType, atomicType, parameterType, alignment) \
        CLANG_ATOMICS_GENERATE(swiftType, atomicType, parameterType, alignment) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, value, fetch_or, Or) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, value, fetch_xor, Xor) \
        CLANG_ATOMICS_RMW(swiftType, parameterType, value, fetch_and, And)

CLANG_ATOMICS_BOOL_GENERATE(AtomicBool, atomic_bool, _Bool, _Alignof(atomic_bool))

#ifdef __CACHE_LINE_WIDTH
CLANG_ATOMICS_INT_GENERATE(AtomicCacheLineAlignedInt, atomic_intptr_t, intptr_t, __CACHE_LINE_WIDTH)
CLANG_ATOMICS_INT_GENERATE(AtomicCacheLineAlignedUInt, atomic_uintptr_t, uintptr_t, __CACHE_LINE_WIDTH)
CLANG_ATOMICS_BOOL_GENERATE(AtomicCacheLineAlignedBool, atomic_bool, _Bool, __CACHE_LINE_WIDTH)
#endif

// pointer atomics

#define CLANG_ATOMICS_POINTER_INITIALIZE(swiftType, parameterType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.initialize(self:_:)) \
        void swiftType##Initialize(swiftType *_Nonnull ptr, parameterType nullability value) \
        { atomic_init(&(ptr->a), (uintptr_t)value); }

#define CLANG_ATOMICS_POINTER_CREATE(swiftType, parameterType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.init(_:)) \
        swiftType swiftType##Create(parameterType nullability value) \
        { swiftType s; swiftType##Initialize(&s, value); return s; }

#define CLANG_ATOMICS_POINTER_LOAD(swiftType, parameterType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.load(self:_:)) \
        parameterType nullability swiftType##Load(swiftType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { return (parameterType) atomic_load_explicit(&(ptr->a), order); }

#define CLANG_ATOMICS_POINTER_STORE(swiftType, parameterType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.store(self:_:_:)) \
        void swiftType##Store(swiftType *_Nonnull ptr, parameterType nullability value, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), (uintptr_t)value, order); }

#define CLANG_ATOMICS_POINTER_SWAP(swiftType, parameterType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.swap(self:_:_:)) \
        parameterType nullability swiftType##Swap(swiftType *_Nonnull ptr, parameterType nullability value, enum MemoryOrder order) \
        { return (parameterType) atomic_exchange_explicit(&(ptr->a), (uintptr_t)value, order); }

#define CLANG_ATOMICS_POINTER_CAS(swiftType, parameterType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.loadCAS(self:_:_:_:_:_:)) \
        _Bool swiftType##LoadCAS(swiftType *_Nonnull ptr, parameterType nullability* _Nonnull current, parameterType nullability future, \
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
        SWIFT_NAME(swiftType.CAS(self:_:_:_:_:)) \
        _Bool swiftType##CAS(swiftType *_Nonnull ptr, parameterType nullability current, parameterType nullability future, \
                             enum CASType type, enum MemoryOrder order) \
        { \
          parameterType expect = current; \
          return swiftType##LoadCAS(ptr, &expect, future, type, order, LoadMemoryOrder_relaxed); \
        }

#define CLANG_ATOMICS_POINTER_GENERATE(swiftType, atomicType, parameterType, nullability, alignment) \
        CLANG_ATOMICS_STRUCT(swiftType, atomicType, alignment) \
        CLANG_ATOMICS_IS_LOCK_FREE(swiftType) \
        CLANG_ATOMICS_POINTER_INITIALIZE(swiftType, parameterType, nullability) \
        CLANG_ATOMICS_POINTER_CREATE(swiftType, parameterType, nullability) \
        CLANG_ATOMICS_POINTER_LOAD(swiftType, parameterType, nullability) \
        CLANG_ATOMICS_POINTER_STORE(swiftType, parameterType, nullability) \
        CLANG_ATOMICS_POINTER_SWAP(swiftType, parameterType, nullability) \
        CLANG_ATOMICS_POINTER_CAS(swiftType, parameterType, nullability)

// would prefer to call it "AtomicMutableRawPointer", but that was the former name of "AtomicOptionalMutableRawPointer"...
CLANG_ATOMICS_POINTER_GENERATE(AtomicNonNullMutableRawPointer, atomic_uintptr_t, void*, _Nonnull, _Alignof(atomic_uintptr_t))
CLANG_ATOMICS_POINTER_GENERATE(AtomicOptionalMutableRawPointer, atomic_uintptr_t, void*, _Nullable, _Alignof(atomic_uintptr_t))

CLANG_ATOMICS_POINTER_GENERATE(AtomicNonNullRawPointer, atomic_uintptr_t, const void*, _Nonnull, _Alignof(atomic_uintptr_t))
CLANG_ATOMICS_POINTER_GENERATE(AtomicOptionalRawPointer, atomic_uintptr_t, const void*, _Nullable, _Alignof(atomic_uintptr_t))

#ifdef __CACHE_LINE_WIDTH
CLANG_ATOMICS_POINTER_GENERATE(AtomicCacheLineAlignedMutableRawPointer, atomic_uintptr_t, void*, _Nonnull, __CACHE_LINE_WIDTH)
CLANG_ATOMICS_POINTER_GENERATE(AtomicCacheLineAlignedOptionalMutableRawPointer, atomic_uintptr_t, void*, _Nullable, __CACHE_LINE_WIDTH)
CLANG_ATOMICS_POINTER_GENERATE(AtomicCacheLineAlignedRawPointer, atomic_uintptr_t, const void*, _Nonnull, __CACHE_LINE_WIDTH)
CLANG_ATOMICS_POINTER_GENERATE(AtomicCacheLineAlignedOptionalRawPointer, atomic_uintptr_t, const void*, _Nullable, __CACHE_LINE_WIDTH)
#endif

struct opaque;

CLANG_ATOMICS_POINTER_GENERATE(AtomicNonNullOpaquePointer, atomic_uintptr_t, struct opaque*, _Nonnull, _Alignof(atomic_uintptr_t))
CLANG_ATOMICS_POINTER_GENERATE(AtomicOptionalOpaquePointer, atomic_uintptr_t, struct opaque*, _Nullable, _Alignof(atomic_uintptr_t))

// tagged pointers -- double-word load, store and CAS

#define CLANG_ATOMICS_TAGGED_POINTER_STRUCT(swiftType, unionType, pointerType, nullability) \
        typedef union { \
          unionType tag_ptr; \
          struct { \
            pointerType nullability ptr; \
            long tag; \
          }; \
        } swiftType;

#define CLANG_ATOMICS_TAGGED_POINTER_CREATE(swiftType, pointerType, nullability) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.init(_:tag:)) \
        swiftType swiftType##Create(pointerType nullability ptr, long tag) \
        { swiftType s; s.tag = tag; s.ptr = ptr; return s; } \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.init(_:)) \
        swiftType swiftType##CreateDefaultTag(pointerType nullability ptr) \
        { return swiftType##Create(ptr, 0); }

#define CLANG_ATOMICS_TAGGED_POINTER_INCREMENT(swiftType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.increment(self:)) \
        void swiftType##Increment(swiftType *_Nonnull ptr) \
        { ptr->tag++; } \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(swiftType.incremented(self:)) \
        swiftType swiftType##Incremented(swiftType t) \
        { swiftType s; s = t; s.tag++; return s; }

#define CLANG_ATOMICS_TAGGED_POINTER_INITIALIZE(atomicType, structType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.initialize(self:_:)) \
        void atomicType##Initialize(atomicType *_Nonnull ptr, structType value) \
        { atomic_init(&(ptr->a), value.tag_ptr); } \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.init(_:)) \
        atomicType atomicType##Create(structType value) \
        { atomicType s; atomicType##Initialize(&s, value); return s; }

#define CLANG_ATOMICS_TAGGED_POINTER_LOAD(atomicType, structType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.load(self:_:)) \
        structType atomicType##Load(atomicType *_Nonnull ptr, enum LoadMemoryOrder order) \
        { structType rp; rp.tag_ptr = atomic_load_explicit(&(ptr->a), order); return rp; }

#define CLANG_ATOMICS_TAGGED_POINTER_STORE(atomicType, structType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.store(self:_:_:)) \
        void atomicType##Store(atomicType *_Nonnull ptr, structType value, enum StoreMemoryOrder order) \
        { atomic_store_explicit(&(ptr->a), value.tag_ptr, order); }

#define CLANG_ATOMICS_TAGGED_POINTER_SWAP(atomicType, structType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.swap(self:_:_:)) \
        structType atomicType##Swap(atomicType *_Nonnull ptr, structType value, enum MemoryOrder order) \
        { structType rp; rp.tag_ptr = atomic_exchange_explicit(&(ptr->a), value.tag_ptr, order); return rp; }

#define CLANG_ATOMICS_TAGGED_POINTER_CAS(atomicType, structType) \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.loadCAS(self:_:_:_:_:_:)) \
        _Bool atomicType##LoadCAS(atomicType *_Nonnull ptr, structType *_Nonnull current, structType future, \
                                         enum CASType type, enum MemoryOrder orderSwap, enum LoadMemoryOrder orderLoad) \
        { \
          assert((unsigned int)orderLoad <= (unsigned int)orderSwap); \
          assert(orderSwap == __ATOMIC_RELEASE ? orderLoad == __ATOMIC_RELAXED : true); \
          if(type == __ATOMIC_CAS_TYPE_STRONG) \
            return atomic_compare_exchange_strong_explicit(&(ptr->a), &(current->tag_ptr), future.tag_ptr, orderSwap, orderLoad); \
          else \
            return atomic_compare_exchange_weak_explicit(&(ptr->a), &(current->tag_ptr), future.tag_ptr, orderSwap, orderLoad); \
        } \
        static __inline__ __attribute__((__always_inline__)) \
        SWIFT_NAME(atomicType.CAS(self:_:_:_:_:)) \
        _Bool atomicType##CAS(atomicType *_Nonnull ptr, structType current, structType future, \
                                     enum CASType type, enum MemoryOrder order) \
        { \
          structType expect = current; \
          return atomicType##LoadCAS(ptr, &expect, future, type, order, LoadMemoryOrder_relaxed); \
        }

#if defined(__has32bitPointer__)
#define __UNION_TYPE long long
#else
#define __UNION_TYPE __int128
#endif

#define CLANG_ATOMICS_TAGGED_POINTER_GENERATE(swiftType, pointerType, nullability) \
        CLANG_ATOMICS_TAGGED_POINTER_STRUCT(swiftType, __UNION_TYPE, pointerType, nullability) \
        CLANG_ATOMICS_TAGGED_POINTER_CREATE(swiftType, pointerType, nullability) \
        CLANG_ATOMICS_TAGGED_POINTER_INCREMENT(swiftType)

#define CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(atomicType, structType, alignment) \
        CLANG_ATOMICS_STRUCT(atomicType, _Atomic(__UNION_TYPE), alignment) \
        CLANG_ATOMICS_IS_LOCK_FREE(atomicType) \
        CLANG_ATOMICS_TAGGED_POINTER_INITIALIZE(atomicType, structType) \
        CLANG_ATOMICS_TAGGED_POINTER_LOAD(atomicType, structType) \
        CLANG_ATOMICS_TAGGED_POINTER_STORE(atomicType, structType) \
        CLANG_ATOMICS_TAGGED_POINTER_SWAP(atomicType, structType) \
        CLANG_ATOMICS_TAGGED_POINTER_CAS(atomicType, structType)

CLANG_ATOMICS_TAGGED_POINTER_GENERATE(TaggedRawPointer, const void*, _Nonnull)
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicTaggedRawPointer, TaggedRawPointer, _Alignof(_Atomic(__UNION_TYPE)))
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicCacheLineAlignedTaggedRawPointer, TaggedRawPointer, __CACHE_LINE_WIDTH)

CLANG_ATOMICS_TAGGED_POINTER_GENERATE(TaggedOptionalRawPointer, const void*, _Nullable)
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicTaggedOptionalRawPointer, TaggedOptionalRawPointer, _Alignof(_Atomic(__UNION_TYPE)))
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicCacheLineAlignedTaggedOptionalRawPointer, TaggedOptionalRawPointer, __CACHE_LINE_WIDTH)

CLANG_ATOMICS_TAGGED_POINTER_GENERATE(TaggedMutableRawPointer, void*, _Nonnull)
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicTaggedMutableRawPointer, TaggedMutableRawPointer, _Alignof(_Atomic(__UNION_TYPE)))
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicCacheLineAlignedTaggedMutableRawPointer, TaggedMutableRawPointer, __CACHE_LINE_WIDTH)

CLANG_ATOMICS_TAGGED_POINTER_GENERATE(TaggedOptionalMutableRawPointer, void*, _Nullable)
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicTaggedOptionalMutableRawPointer, TaggedOptionalMutableRawPointer, _Alignof(_Atomic(__UNION_TYPE)))
CLANG_ATOMICS_ATOMIC_TAGGED_POINTER_GENERATE(AtomicCacheLineAlignedTaggedOptionalMutableRawPointer, TaggedOptionalMutableRawPointer, __CACHE_LINE_WIDTH)

// fence

static __inline__ __attribute__((__always_inline__))
void CAtomicsThreadFence(enum MemoryOrder order)
{
  atomic_thread_fence(order);
}

// unmanaged

#define __OPAQUE_UNMANAGED_LOCKED   (uintptr_t)0x7
#define __OPAQUE_UNMANAGED_SPINMASK (char)0xc0

CLANG_ATOMICS_STRUCT(OpaqueUnmanagedHelper, atomic_uintptr_t, _Alignof(atomic_uintptr_t))
CLANG_ATOMICS_IS_LOCK_FREE(OpaqueUnmanagedHelper)
CLANG_ATOMICS_POINTER_INITIALIZE(OpaqueUnmanagedHelper, const void*, _Nullable)

// this should only be used for unlocking
CLANG_ATOMICS_POINTER_STORE(OpaqueUnmanagedHelper, const void*, _Nullable)

// this should only be used for debugging and testing
CLANG_ATOMICS_POINTER_LOAD(OpaqueUnmanagedHelper, const void*, _Nullable)

static __inline__ __attribute__((__always_inline__)) \
SWIFT_NAME(OpaqueUnmanagedHelper.lockAndLoad(self:_:)) \
const void *_Nullable UnmanagedLockAndLoad(OpaqueUnmanagedHelper *_Nonnull ptr, enum LoadMemoryOrder order)
{ // load the pointer value, and leave the pointer either LOCKED or NULL; spin for the lock if necessary
#ifndef __SSE2__
  char c;
  c = 0;
#endif
  uintptr_t pointer;
  pointer = atomic_load_explicit(&(ptr->a), order);
  do { // don't fruitlessly invalidate the cache line if the value is locked
    while (pointer == __OPAQUE_UNMANAGED_LOCKED)
    {
#ifdef __SSE2__
      _mm_pause();
#else
      c += 1;
      if ((c&__OPAQUE_UNMANAGED_SPINMASK) != 0) { sched_yield(); }
#endif
      pointer = atomic_load_explicit(&(ptr->a), order);
    }
    // return immediately if pointer is NULL (importantly: without locking)
    if (pointer == (uintptr_t) NULL) { return NULL; }
  } while(!atomic_compare_exchange_weak_explicit(&(ptr->a), &pointer, __OPAQUE_UNMANAGED_LOCKED, order, order));

  return (void*) pointer;
}

static __inline__ __attribute__((__always_inline__)) \
SWIFT_NAME(OpaqueUnmanagedHelper.spinSwap(self:_:_:)) \
const void *_Nullable UnmanagedSpinSwap(OpaqueUnmanagedHelper *_Nonnull ptr, const void *_Nullable value, enum MemoryOrder order)
{ // swap the pointer with `value`, spinning until the lock becomes unlocked if necessary
#ifndef __SSE2__
  char c;
  c = 0;
#endif
  uintptr_t pointer;
  pointer = atomic_load_explicit(&(ptr->a), __ATOMIC_RELAXED);
  do { // don't fruitlessly invalidate the cache line if the value is locked
    while (pointer == __OPAQUE_UNMANAGED_LOCKED)
    {
#ifdef __SSE2__
      _mm_pause();
#else
      c += 1;
      if ((c&__OPAQUE_UNMANAGED_SPINMASK) != 0) { sched_yield(); }
#endif
      pointer = atomic_load_explicit(&(ptr->a), __ATOMIC_RELAXED);
    }
  } while(!atomic_compare_exchange_weak_explicit(&(ptr->a), &pointer, (uintptr_t)value, order, __ATOMIC_RELAXED));

  return (void*) pointer;
}

static __inline__ __attribute__((__always_inline__)) \
SWIFT_NAME(OpaqueUnmanagedHelper.CAS(self:_:_:_:_:)) \
_Bool UnmanagedCompareAndSwap(OpaqueUnmanagedHelper *_Nonnull ptr, const void *_Nullable current, const void *_Nullable future,
                              enum CASType type, enum MemoryOrder order)
{
  if(type == __ATOMIC_CAS_TYPE_WEAK)
  {
    uintptr_t pointer = (uintptr_t) current;
    return atomic_compare_exchange_weak_explicit(&(ptr->a), &pointer, (uintptr_t)future, order, memory_order_relaxed);
  }
  else
  { // we should consider that __OPAQUE_UNMANAGED_LOCKED is a spurious value
#ifndef __SSE2__
    char c;
    c = 0;
#endif
    _Bool success;
    while (true)
    {
      uintptr_t pointer = (uintptr_t) current;
      success = atomic_compare_exchange_strong_explicit(&(ptr->a), &pointer, (uintptr_t)future, order, memory_order_relaxed);
      if (pointer != __OPAQUE_UNMANAGED_LOCKED) { break; }

      while (pointer == __OPAQUE_UNMANAGED_LOCKED)
      { // don't fruitlessly invalidate the cache line if the value is locked
#ifdef __SSE2__
        _mm_pause();
#else
        c += 1;
        if ((c&__OPAQUE_UNMANAGED_SPINMASK) != 0) { sched_yield(); }
#endif
        pointer = atomic_load_explicit(&(ptr->a), __ATOMIC_RELAXED);
      }
    }
    return success;
  }
}

#undef __CACHE_LINE_WIDTH
#endif
