// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Analytics",
            targets: ["Analytics"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Analytics",
            dependencies: []),
        .testTarget(
            name: "AnalyticsTests",
            dependencies: ["Analytics"]),
    ]
)
