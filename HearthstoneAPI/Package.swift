// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "HearthstoneAPI",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "HearthstoneAPI",
            targets: [
                "HearthstoneAPI",
            ]
        ),
    ],
    targets: [
        .target(name: "HearthstoneAPI"),
        .testTarget(
            name: "HearthstoneAPITests",
            dependencies: [
                "HearthstoneAPI",
            ]
        ),
    ]
)
