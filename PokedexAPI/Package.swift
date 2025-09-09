// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PokedexAPI",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PokedexAPI",
            targets: ["PokedexAPI"]),
        .executable(
            name: "PokedexAPIRunner",
            targets: ["PokedexAPIRunner"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PokedexAPI"),
        .executableTarget(
            name: "PokedexAPIRunner",
            dependencies: ["PokedexAPI"]
        ),
        .testTarget(
            name: "PokedexAPITests",
            dependencies: ["PokedexAPI"]
        ),
    ]
)
