// swift-tools-version:4.2

import PackageDescription

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
  swiftLanguageVersions: [.v3, .v4, .v4_2, .version("5")]
)

#else

let package = Package(
  name: "Atomics",
  targets: [
    Target(name: "Atomics", dependencies: ["CAtomics"]),
  ]
)

#endif
