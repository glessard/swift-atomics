import PackageDescription

let package = Package(
    name: "Atomics",
    targets: [
      Target(name: "Atomics", dependencies: ["ClangAtomics"]),
    ]
)
