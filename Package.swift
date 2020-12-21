// swift-tools-version:3.1.0

import PackageDescription

let package = Package(
  name: "SwiftAtomics",
  targets: [
    Target(name: "SwiftAtomics", dependencies: ["CAtomics"]),
  ]
)
