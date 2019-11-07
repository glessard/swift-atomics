// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "SwiftAtomics",
  products: [
    .library(name: "SwiftAtomics", type: .static, targets: ["SwiftAtomics"]),
    .library(name: "CAtomics", type: .static, targets: ["CAtomics"]),
  ],
  targets: [
    .target(name: "SwiftAtomics", dependencies: ["CAtomics"]),
    .testTarget(name: "SwiftAtomicsTests", dependencies: ["SwiftAtomics"]),
    .target(name: "CAtomics", dependencies: []),
    .testTarget(name: "CAtomicsTests", dependencies: ["CAtomics"]),
  ],
  swiftLanguageVersions: [3, 4, 5]
)
