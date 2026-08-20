// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVDatabaseKit",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SVDatabaseKit",
            targets: ["SVDatabaseKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/groue/GRDB.swift.git",
            from: "7.0.0"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SVDatabaseKit",
            dependencies: [
                .product(
                    name: "GRDB",
                    package: "GRDB.swift"
                )
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "SVDatabaseKitTests",
            dependencies: ["SVDatabaseKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
