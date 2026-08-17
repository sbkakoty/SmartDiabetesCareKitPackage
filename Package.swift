// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SmartDiabetesCareKitPackage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SmartDiabetesCareKit",
            targets: ["SmartDiabetesCareKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "SmartDiabetesCareKit",
            url: "https://github.com/sbkakoty/SmartDiabetesCareKit/releases/download/1.2.0/SmartDiabetesCareKit.xcframework.zip",
            checksum: "c69fd279d45636ab894da9e8e26ff9665cede7260fcf2ecc7d8c2ebda4f0770f"
        )
    ]
)