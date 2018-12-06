//
//  RandomPositive.swift
//

#if !swift(>=4.2)
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import func Darwin.C.stdlib.arc4random
#else // assuming os(Linux)
import func Glibc.random
#endif
#endif

#if swift(>=4.0)
extension FixedWidthInteger where Self.Magnitude: UnsignedInteger, Self.Stride: SignedInteger
{
  // returns a positive random integer greater than 0 and less-than-or-equal to Self.max/2
  static func randomPositive() -> Self
  {
#if swift(>=4.1.50)
    return Self.random(in: 1...(Self.max>>1))
#else
    var t = Self()
    repeat {
      for _ in 0...((t.bitWidth-1)/32)
      {
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        t = t<<32 &+ Self(truncatingIfNeeded: arc4random())
#else // probably Linux
        t = t<<32 &+ Self(truncatingIfNeeded: random())
#endif
      }
    } while t == Self()

    return t & (Self.max>>1)
#endif
  }
}
#else
extension UInt
{
  // returns a positive random integer greater than 0 and less-than-or-equal to UInt32.max/2
  // in this variant the least significant bit is always set.
  static func randomPositive() -> UInt
  {
    var t: UInt
    repeat {
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
      t = UInt(arc4random())
#else
      t = UInt(random())
#endif
      t &= 0x3fff_ffff
    } while t == 0

    return t
  }
}
#endif
