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
    ],
    dependencies: [
        .package(url: "https://github.com/klassen-software-solutions/KSSCore.git", .branch("development/v4") /*from: "3.2.1"*/),
    ],
    targets: [
        .target(name: "KSSCocoa", dependencies: [.product(name: "KSSFoundation", package: "KSSCore")]),
        .target(name: "KSSMap", dependencies: ["KSSCocoa"]),
        .testTarget(name: "KSSCocoaTests", dependencies: ["KSSCocoa", .product(name: "KSSTest", package: "KSSCore")]),
    ]
)
