// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSMainKit",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iOSMainKit",
            targets: ["iOSMainKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../iOSHomeKit"),
        .package(path: "../iOSProjectKit"),
        .package(path: "../iOSLibraryKit"),
        .package(path: "../iOSSettingsKit"),
        .package(path: "../../Modules/SVFoundation"),
        .package(path: "../../Modules/SVSpotlightKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iOSMainKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "iOSHomeKit", package: "iOSHomeKit"),
                .product(name: "iOSProjectKit", package: "iOSProjectKit"),
                .product(name: "iOSLibraryKit", package: "iOSLibraryKit"),
                .product(name: "iOSSettingsKit", package: "iOSSettingsKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
                .product(name: "SVSpotlightKit", package: "SVSpotlightKit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "iOSMainKitTests",
            dependencies: ["iOSMainKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
