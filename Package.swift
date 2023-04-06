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
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SpiralSDK_Tests",
            dependencies: ["SpiralSDK"],
            path: "Example/Tests"
        ),
    ]
)
