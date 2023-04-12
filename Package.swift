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
            resources: [.process("Resources/Assets")]
        ),
        .testTarget(
            name: "SpiralSDK_Tests",
            dependencies: ["SpiralSDK"],
            path: "Example/Tests"
        ),
    ]
)
