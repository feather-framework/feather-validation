# Feather Validation

A validation library for server-side Swift projects.

[
    ![Release: 1.0.0-beta.1](https://img.shields.io/badge/Release-1%2E0%2E0--beta%2E1-F05138)
](
    https://github.com/feather-framework/feather-validation/releases/tag/1.0.0-beta.1
)

## Features

- Key-value based validation primitives
- Composable rules for string and integer validation
- Async and grouped validation strategies
- Foundation-based rules for URL, email, password, and character sets

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: Linux, macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-Linux_%7C_macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.1+

- Platforms:
  - Linux
  - macOS 15+
  - iOS 18+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-validation.git", exact: "1.0.0-beta.1"),
```

Then add `FeatherValidation` (and optionally `FeatherValidationFoundation`) to your target dependencies:

```swift
.product(name: "FeatherValidation", package: "feather-validation"),
.product(name: "FeatherValidationFoundation", package: "feather-validation"),
```

## Usage

[
    ![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)
](
    https://feather-framework.github.io/feather-validation/
)

API documentation is available at the following link.

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Development

- Build: `swift build`
- Test:
  - local: `swift test`
  - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-validation/pulls) are welcome. Please keep changes focused and include tests for new logic.
