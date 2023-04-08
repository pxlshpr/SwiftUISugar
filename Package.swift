// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUISugar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftUISugar",
            targets: ["SwiftUISugar"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pxlshpr/SwiftHaptics", from: "0.1.3"),
        .package(url: "https://github.com/pxlshpr/SwiftSugar", from: "0.0.90"),
        .package(url: "https://github.com/pxlshpr/MarqueeText", from: "0.0.1"),
        .package(url: "https://github.com/exyte/ActivityIndicatorView", from: "1.1.0"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.1.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftUISugar",
            dependencies: [
                .product(name: "SwiftHaptics", package: "swifthaptics"),
                .product(name: "SwiftSugar", package: "swiftsugar"),
                .product(name: "MarqueeText", package: "marqueetext"),
                .product(name: "ActivityIndicatorView", package: "activityindicatorview"),
                .product(name: "Introspect", package: "swiftui-introspect"),
            ]),
        .testTarget(
            name: "SwiftUISugarTests",
            dependencies: ["SwiftUISugar"]),
    ]
)
