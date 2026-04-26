// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "bbc",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "bbc", targets: ["bbc"]),
    ],
    targets: [
        .target(
            name: "bbc",
            path: "src"
        ),
    ]
)
