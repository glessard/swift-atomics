// swift-tools-version:4.0

import PackageDescription

#if swift(>=4.0)

let package = Package(
  name: "Atomics",
  products: [
    .library(name: "Atomics", type: .static, targets: ["Atomics"]),
  ],
  targets: [
    .target(name: "Atomics", dependencies: ["ClangAtomics"]),
    .testTarget(name: "AtomicsTests", dependencies: ["Atomics"]),
    .target(name: "ClangAtomics", dependencies: []),
    .testTarget(name: "ClangAtomicsTests", dependencies: ["ClangAtomics"]),
  ]
)

#else

let package = Package(
  name: "Atomics",
  targets: [
    Target(name: "Atomics", dependencies: ["ClangAtomics"]),
  ]
)

#endif
