// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nophan",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Nophan",
            targets: ["Nophan"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/guardian/qalam.git", branch: "main"),
//        .package(url: "https://github.com/guardian/fonts.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Nophan",
            dependencies: [
                // Add Qalam as a dependency to the Nophan target
                .product(name: "Qalam", package: "qalam"),
//                .product(name: "GuardianFonts", package: "fonts")
            ]),
        .testTarget(
            name: "NophanTests",
            dependencies: ["Nophan"]),
    ]
)
