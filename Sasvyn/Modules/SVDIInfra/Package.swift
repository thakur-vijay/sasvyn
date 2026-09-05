// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVDIInfra",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SVDIInfra",
            targets: ["SVDIInfra"]
        ),
    ],
    dependencies: [
        .package(path: "../SVDatabaseKit"),
        .package(path: "../SVSkillsKit"),
        .package(path: "../SVDocumentKit"),
        .package(path: "../SVProjectKit"),
        .package(path: "../SVMockupKit"),
        .package(path: "../SVEducationKit"),
        .package(path: "../SVExperienceKit"),
        .package(path: "../SVLanguageKit"),
        .package(path: "../SVSocialLinkKit"),
        .package(path: "../SVSpotlightKit"),
        .package(path: "../../iOS/iOSRootKit"),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.26.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SVDIInfra",
            dependencies: [
                .product(name: "SVDatabaseKit", package: "SVDatabaseKit"),
                .product(name: "SVSkillsKit", package: "SVSkillsKit"),
                .product(name: "SVDocumentKit", package: "SVDocumentKit"),
                .product(name: "SVProjectKit", package: "SVProjectKit"),
                .product(name: "SVMockupKit", package: "SVMockupKit"),
                .product(name: "SVEducationKit", package: "SVEducationKit"),
                .product(name: "SVExperienceKit", package: "SVExperienceKit"),
                .product(name: "SVLanguageKit", package: "SVLanguageKit"),
                .product(name: "SVSocialLinkKit", package: "SVSocialLinkKit"),
                .product(name: "SVSpotlightKit", package: "SVSpotlightKit"),
                .product(name: "iOSRootKit", package: "iOSRootKit"),
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "SVDIInfraTests",
            dependencies: ["SVDIInfra"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
