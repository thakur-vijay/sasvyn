// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVPersonalInformationKit",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SVPersonalInformationKit",
            targets: ["SVPersonalInformationKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../SVDatabaseKit"),
        .package(path: "../SVFoundation"),
        .package(path: "../SVNetwork"),
        .package(
            url: "https://github.com/thakur-vijay/NetworkKit.git",
            from: "1.0.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SVPersonalInformationKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "SVDatabaseKit", package: "SVDatabaseKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
                .product(name: "SVNetwork", package: "SVNetwork"),
                .product(name: "NetworkKit", package: "NetworkKit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "SVPersonalInformationKitTests",
            dependencies: ["SVPersonalInformationKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ]
)
