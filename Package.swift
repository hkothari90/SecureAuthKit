// swift-tools-version:5.9
// SecureAuthKit: A secure authentication SDK for iOS with biometrics, PKCE, JWT, and OAuth2 support

import PackageDescription

let package = Package(
    name: "SecureAuthKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "SecureAuthKit", targets: ["SecureAuthKit"]),
        .library(name: "SecureAuthKitMocks", targets: ["SecureAuthKitMocks"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SecureAuthKit",
            path: "Sources/SecureAuthKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .target(
            name: "SecureAuthKitMocks",
            dependencies: ["SecureAuthKit"],
            path: "Sources/SecureAuthKitMocks"
        ),
        .testTarget(
            name: "SecureAuthKitTests",
            dependencies: ["SecureAuthKit", "SecureAuthKitMocks"],
            path: "Tests/SecureAuthKitTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
