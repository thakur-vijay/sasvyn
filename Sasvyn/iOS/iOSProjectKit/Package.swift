// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSProjectKit",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iOSProjectKit",
            targets: ["iOSProjectKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../../Modules/SVRemoteImage"),
        .package(path: "../../Modules/SVDesignSystem"),
        .package(path: "../../Modules/SVProjectKit"),
        .package(path: "../../Modules/SVFoundation"),
        .package(path: "../../Modules/SVSkillsKit"),
        .package(path: "../iOSSkillsKit"),
        .package(path: "../iOSMockupKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iOSProjectKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "SVRemoteImage", package: "SVRemoteImage"),
                .product(name: "SVDesignSystem", package: "SVDesignSystem"),
                .product(name: "SVProjectKit", package: "SVProjectKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
                .product(name: "SVSkillsKit", package: "SVSkillsKit"),
                .product(name: "iOSSkillsKit", package: "iOSSkillsKit"),
                .product(name: "iOSMockupKit", package: "iOSMockupKit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "iOSProjectKitTests",
            dependencies: ["iOSProjectKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
