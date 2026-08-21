// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVProjectKit",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SVProjectKit",
            targets: ["SVProjectKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../SVDatabaseKit"),
        .package(path: "../SVFoundation"),
        .package(path: "../SVDesignSystem"),
        .package(path: "../SVSkillsKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SVProjectKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "SVDatabaseKit", package: "SVDatabaseKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
                .product(name: "SVDesignSystem", package: "SVDesignSystem"),
                .product(name: "SVSkillsKit", package: "SVSkillsKit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "SVProjectKitTests",
            dependencies: ["SVProjectKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
