// swift-tools-version:4.0

import PackageDescription

#if !swift(>=4.2)
let versions = [3,4]
#else
let versions = [SwiftVersion.v3, .v4, .v4_2]
#endif

#if swift(>=4.0)

let package = Package(
  name: "Atomics",
  products: [
    .library(name: "Atomics", type: .static, targets: ["Atomics"]),
    .library(name: "CAtomics", type: .static, targets: ["CAtomics"]),
  ],
  targets: [
    .target(name: "Atomics", dependencies: ["CAtomics"]),
    .testTarget(name: "AtomicsTests", dependencies: ["Atomics"]),
    .target(name: "CAtomics", dependencies: []),
    .testTarget(name: "CAtomicsTests", dependencies: ["CAtomics"]),
  ],
  swiftLanguageVersions: versions
)

#else

let package = Package(
  name: "Atomics",
  targets: [
    Target(name: "Atomics", dependencies: ["CAtomics"]),
  ]
)

#endif
