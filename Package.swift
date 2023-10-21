// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "feather-validation",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "FeatherValidation", targets: ["FeatherValidation"]),
        .library(name: "FeatherValidationFoundation", targets: ["FeatherValidationFoundation"]),
    ],
//    dependencies: [
//        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
//    ],
    targets: [
        .target(
            name: "FeatherValidation"
        ),
        .target(
            name: "FeatherValidationFoundation",
            dependencies: [
                .target(name: "FeatherValidation")
            ]
        ),
        .testTarget(
            name: "FeatherValidationTests",
            dependencies: [
                .target(name: "FeatherValidation")
            ]
        ),
        .testTarget(
            name: "FeatherValidationFoundationTests",
            dependencies: [
                .target(name: "FeatherValidationFoundation")
            ]
        ),
    ]
)
