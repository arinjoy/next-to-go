// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationLayer",
    platforms: [.iOS(.v15), .watchOS(.v7)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PresentationLayer",
            targets: ["PresentationLayer"]),
    ],
    dependencies: [
        .package(path: "../SharedUtils"),
        .package(path: "../DomainLayer"),
        .package(path: "../DataLayer"),
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.2.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PresentationLayer",
            dependencies: ["SharedUtils",
                           "DomainLayer",
                           "DataLayer"],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "PresentationLayerTests",
            dependencies: ["PresentationLayer"],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
        ),
    ]
)
