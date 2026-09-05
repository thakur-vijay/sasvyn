// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSRootKit",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iOSRootKit",
            targets: ["iOSRootKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../iOSAuthKit"),
        .package(path: "../iOSMainKit"),
        .package(path: "../iOSAppearanceKit"),
        .package(path: "../../Modules/SVFoundation"),
        .package(path: "../../Modules/SVSpotlightKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iOSRootKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "iOSAuthKit", package: "iOSAuthKit"),
                .product(name: "iOSMainKit", package: "iOSMainKit"),
                .product(name: "iOSAppearanceKit", package: "iOSAppearanceKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
                .product(name: "SVSpotlightKit", package: "SVSpotlightKit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "iOSRootKitTests",
            dependencies: ["iOSRootKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
