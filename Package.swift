// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PathControl",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "PathControl",
            targets: ["PathControl"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PathControl",
            dependencies: []),
        .testTarget(
            name: "PathControlTests",
            dependencies: ["PathControl"]),
    ]
)
