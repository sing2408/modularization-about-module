// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AboutPackage",
    products: [
        .library(
            name: "AboutPackage",
            targets: ["AboutPackage"]),
    ],
    dependencies: [
        .package(path: "../Core"), 
    ],
    targets: [
        .target(
            name: "AboutPackage",
            dependencies: [.product(name: "Core", package: "Core")]), 
        .testTarget(
            name: "AboutPackageTests",
            dependencies: ["AboutPackage"]),
    ]
)
