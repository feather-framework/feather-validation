# Feather Validation

A generic purpose validation library for server side Swift projects.

## Getting started

⚠️ This repository is a work in progress, things can break until it reaches v1.0.0. 

Use at your own risk.

### Adding the dependency

To add a dependency on the package, declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/feather-framework/feather-validation.git", .upToNextMinor(from: "0.1.0")),
```

and to your application target, add `FeatherValidation` to your dependencies:

```swift
.product(name: "FeatherValidation", package: "feather-validation")
```

Example `Package.swift` file with `FeatherValidation` as a dependency:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "my-application",
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-validation.git", .upToNextMinor(from: "0.1.0")),
    ],
    targets: [
        .target(name: "MyApplication", dependencies: [
            .product(name: "FeatherValidation", package: "feather-validation")
        ]),
        .testTarget(name: "MyApplicationTests", dependencies: [
            .target(name: "MyApplication"),
        ]),
    ]
)
```

###  Using FeatherValidation

See the `FeatherValidationTests` target for validation examples.
