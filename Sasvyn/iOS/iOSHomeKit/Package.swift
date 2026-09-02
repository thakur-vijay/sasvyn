// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSHomeKit",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iOSHomeKit",
            targets: ["iOSHomeKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../iOSPortfolioKit"),
        .package(path: "../iOSProjectKit"),
        .package(path: "../../Modules/SVProjectKit"),
        .package(path: "../../Modules/SVFoundation")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iOSHomeKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "iOSPortfolioKit", package: "iOSPortfolioKit"),
                .product(name: "iOSProjectKit", package: "iOSProjectKit"),
                .product(name: "SVProjectKit", package: "SVProjectKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "iOSHomeKitTests",
            dependencies: ["iOSHomeKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
