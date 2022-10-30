// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ESharingRoot",
    platforms: [
      .iOS(.v15)
    ],
    products: [
        .library(
            name: "ESharingRoot",
            type: .static,
            targets: ["ESharingRoot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git",
                 exact: "5.6.1")
    ],
    targets: [
        .target(
            name: "ESharingRoot",
            dependencies: [
                "Services",
                "Features"],
            path: "ESharingRoot"),
        .target(
            name: "Services",
            dependencies: [
                "Alamofire"],
            path: "Services"),
        .target(
            name: "Features",
            dependencies: [
                "Services"],
            path: "Features")
    ]
)
