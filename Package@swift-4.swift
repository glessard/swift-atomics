// swift-tools-version:4.0

import PackageDescription

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
  swiftLanguageVersions: [3,4,5]
)
