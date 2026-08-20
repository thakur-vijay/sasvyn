// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSLibraryKit",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "iOSLibraryKit",
            targets: ["iOSLibraryKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
        .package(path: "../iOSSkillsKit"),
        .package(path: "../iOSAboutKit"),
        .package(path: "../iOSDocumentsKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "iOSLibraryKit",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(name: "iOSSkillsKit", package: "iOSSkillsKit"),
                .product(name: "iOSAboutKit", package: "iOSAboutKit"),
                .product(name: "iOSDocumentsKit", package: "iOSDocumentsKit"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "iOSLibraryKitTests",
            dependencies: ["iOSLibraryKit"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
