// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "feather-validation",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .library(name: "FeatherValidation", targets: ["FeatherValidation"]),
    ],
    targets: [
        .target(name: "FeatherValidation"),
        .testTarget(
            name: "FeatherValidationTests",
            dependencies: ["FeatherValidation"]
        ),
    ]
)
