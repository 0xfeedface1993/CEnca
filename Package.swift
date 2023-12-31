// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CEnca",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CEnca",
            targets: ["CEnca"]),
        .library(name: "EncodingWrapper", targets: ["EncodingWrapper"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(name: "CEnca", pkgConfig: "enca", providers: [.aptItem(["libenca-dev"]), .brewItem(["enca"])]),
        .target(
            name: "EncodingWrapper",
            dependencies: [
                .target(name: "CEnca"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "CEncaTests",
            dependencies: ["CEnca", "EncodingWrapper"]),
    ]
)

#if os(macOS)
package.targets.first?.path = "Sources/CEnca_macOS"
#endif
