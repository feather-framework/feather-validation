// swift-tools-version:6.1
import PackageDescription

// NOTE: https://github.com/swift-server/swift-http-server/blob/main/Package.swift
var defaultSwiftSettings: [SwiftSetting] = [
    
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0441-formalize-language-mode-terminology.md
    .swiftLanguageMode(.v6),
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),
    // https://forums.swift.org/t/experimental-support-for-lifetime-dependencies-in-swift-6-2-and-beyond/78638
    .enableExperimentalFeature("Lifetimes"),
    // https://github.com/swiftlang/swift/pull/65218
    .enableExperimentalFeature("AvailabilityMacro=featherValidation:macOS 15, iOS 18, watchOS 9, tvOS 11, visionOS 2"),
]

#if compiler(>=6.2)
defaultSwiftSettings.append(
    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
)
#endif

let package = Package(
    name: "feather-validation",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "FeatherValidation", targets: ["FeatherValidation"]),
        .library(name: "FeatherValidationFoundation", targets: ["FeatherValidationFoundation"]),
    ],
    dependencies: [
        // [docc-plugin-placeholder]
    ],
    targets: [
        .target(
            name: "FeatherValidation",
            swiftSettings: defaultSwiftSettings
        ),
        .target(
            name: "FeatherValidationFoundation",
            dependencies: [
                .target(name: "FeatherValidation")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "FeatherValidationTests",
            dependencies: [
                .target(name: "FeatherValidation")
            ],
            swiftSettings: defaultSwiftSettings
        ),
        .testTarget(
            name: "FeatherValidationFoundationTests",
            dependencies: [
                .target(name: "FeatherValidationFoundation")
            ],
            swiftSettings: defaultSwiftSettings
        ),
    ]
)
