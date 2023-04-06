// swift-tools-version:5.1
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
            resources: [
                    .process("Resources")
                ]
            dependencies: []),
        .testTarget(
            name: "SpiralSDK_Tests",
            dependencies: ["SpiralSDK"],
            path: "Example/Tests"
        ),
    ]
)
