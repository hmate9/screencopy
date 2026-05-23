// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ScreenCopy",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ScreenCopy", targets: ["ScreenCopy"]),
        .library(name: "ScreenCopyCore", targets: ["ScreenCopyCore"])
    ],
    targets: [
        .target(name: "ScreenCopyCore"),
        .executableTarget(
            name: "ScreenCopy",
            dependencies: ["ScreenCopyCore"]
        ),
        .testTarget(
            name: "ScreenCopyCoreTests",
            dependencies: ["ScreenCopyCore"]
        )
    ]
)
