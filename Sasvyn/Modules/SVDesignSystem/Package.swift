// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVDesignSystem",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SVDesignSystem",
            targets: ["SVDesignSystem"]
        ),
    ],
    dependencies: [
        .package(path: "../SVRemoteImage"),
        .package(url: "https://github.com/colinc86/LaTeXSwiftUI", from: "2.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SVDesignSystem",
            dependencies: [
                .product(name: "SVRemoteImage", package: "SVRemoteImage"),
                .product(name: "LaTeXSwiftUI", package: "LaTeXSwiftUI"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "SVDesignSystemTests",
            dependencies: ["SVDesignSystem"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
