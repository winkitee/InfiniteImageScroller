// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfiniteImageScroller",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "InfiniteImageScroller",
            targets: ["InfiniteImageScroller"]),
    ],
    targets: [
        .target(
            name: "InfiniteImageScroller"),
    ]
)
