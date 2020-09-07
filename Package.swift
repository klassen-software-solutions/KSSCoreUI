// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KSSCoreUI",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v13),
    ],
    products: [
        .library(name: "KSSCocoa", targets: ["KSSCocoa"]),
        .library(name: "KSSMap", targets: ["KSSMap"]),
        .library(name: "KSSSwiftUI", targets: ["KSSSwiftUI"]),
        .library(name: "KSSWeb", targets: ["KSSWeb"]),
    ],
    dependencies: [
        .package(url: "https://github.com/klassen-software-solutions/KSSCore.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "KSSCocoa", dependencies: [.product(name: "KSSFoundation", package: "KSSCore")]),
        .target(name: "KSSMap", dependencies: []),
        .target(name: "KSSSwiftUI", dependencies: ["KSSCocoa"]),
        .target(name: "KSSWeb", dependencies: []),
        .testTarget(name: "KSSCocoaTests", dependencies: ["KSSCocoa", .product(name: "KSSTest", package: "KSSCore")]),
        .testTarget(name: "KSSSwiftUITests", dependencies: ["KSSSwiftUI", .product(name: "KSSTest", package: "KSSCore")]),
        .testTarget(name: "KSSWebTests", dependencies: ["KSSWeb"]),
    ]
)
