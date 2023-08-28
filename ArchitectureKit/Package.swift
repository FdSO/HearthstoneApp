// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ArchitectureKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "ArchitectureKit",
            targets: [
                "ArchitectureKit",
            ]
        ),
    ],
    targets: [
        .target(name: "ArchitectureKit"),
        .testTarget(
            name: "ArchitectureKitTests",
            dependencies: [
                "ArchitectureKit",
            ]
        ),
    ]
)
