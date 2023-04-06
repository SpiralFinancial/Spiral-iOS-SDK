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
            dependencies: []),
        .testTarget(
            name: "SpiralSDK_Tests",
            dependencies: ["SpiralSDK"],
            resources: [
                    .process("Resources")
                ]
            path: "Example/Tests"
        ),
    ]
)
