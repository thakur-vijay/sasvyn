// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "SVExperienceKit",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [.library(name: "SVExperienceKit", targets: ["SVExperienceKit"])],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.26.0"),
        .package(path: "../SVDatabaseKit"),
        .package(path: "../SVFoundation"),
    ],
    targets: [
        .target(
            name: "SVExperienceKit",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SVDatabaseKit", package: "SVDatabaseKit"),
                .product(name: "SVFoundation", package: "SVFoundation"),
            ],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
        .testTarget(
            name: "SVExperienceKitTests",
            dependencies: ["SVExperienceKit"],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
