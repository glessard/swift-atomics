// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "SwiftAtomics",
  products: [
    .library(name: "SwiftAtomics", targets: ["SwiftAtomics"]),
  ],
  dependencies: [
    .package(url: "https://github.com/glessard/CAtomics", from: "6.5.1"),
  ],
  targets: [
    .target(name: "SwiftAtomics", dependencies: ["CAtomics"]),
    .testTarget(name: "SwiftAtomicsTests", dependencies: ["SwiftAtomics"]),
  ],
  swiftLanguageVersions: [.v3, .v4, .v4_2, .version("5")]
)
