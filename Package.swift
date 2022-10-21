// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUISugar",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftUISugar",
            targets: ["SwiftUISugar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/SwiftHaptics", from: "0.1.0"),
        .package(url: "https://github.com/pxlshpr/SwiftSugar", from: "0.0.62"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftUISugar",
            dependencies: [
                .product(name: "SwiftHaptics", package: "swifthaptics"),
                .product(name: "SwiftSugar", package: "swiftsugar"),
            ]),
        .testTarget(
            name: "SwiftUISugarTests",
            dependencies: ["SwiftUISugar"]),
    ]
)
