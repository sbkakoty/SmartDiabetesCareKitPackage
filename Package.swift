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
            url: "https://github.com/sbkakoty/SmartDiabetesCareKit/releases/download/1.1.0/SmartDiabetesCareKit.xcframework.zip",
            checksum: "21b57d8c35086ec1508de9e5406bd81079e072775980b01133e7c7b00c513a66"
        )
    ]
)