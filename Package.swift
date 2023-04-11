// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SpiralSDK",
    products: [
        .library(
            name: "SpiralSDK",
            targets: ["SpiralSDK"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SpiralSDK",
            dependencies: [],
            resources: [
                .process("Resources/XIB/*"),
                .process("Resources/Assets/SpiralAssets.xcassets"),
                .copy("Resources/Fonts/*")
            ]
        ),
        .testTarget(
            name: "SpiralSDK_Tests",
            dependencies: ["SpiralSDK"],
            path: "Example/Tests"
        ),
    ]
)
