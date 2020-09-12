// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSSCoreUI",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v13),
    ],
    products: [
        .library(name: "KSSMap", targets: ["KSSMap"]),
        .library(name: "KSSNativeUI", targets: ["KSSNativeUI"]),
        .library(name: "KSSSwiftUI", targets: ["KSSSwiftUI"]),
        .library(name: "KSSWeb", targets: ["KSSWeb"]),
    ],
    dependencies: [
        .package(url: "https://github.com/klassen-software-solutions/KSSCore.git", .branch("development/v5") /*from: "4.0.0"*/),
    ],
    targets: [
        .target(name: "KSSNativeUI", dependencies: [.product(name: "KSSFoundation", package: "KSSCore")]),
        .target(name: "KSSMap", dependencies: []),
        .target(name: "KSSSwiftUI", dependencies: ["KSSNativeUI"]),
        .target(name: "KSSWeb", dependencies: []),
        .testTarget(name: "KSSNativeUITests", dependencies: ["KSSNativeUI", .product(name: "KSSTest", package: "KSSCore")]),
        .testTarget(name: "KSSSwiftUITests", dependencies: ["KSSSwiftUI", .product(name: "KSSTest", package: "KSSCore")]),
        .testTarget(name: "KSSWebTests", dependencies: ["KSSWeb"]),
    ]
)
