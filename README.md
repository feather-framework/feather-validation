# Feather Validation

A validation library for server-side Swift projects.

[![Release: 1.0.0-beta.1](https://img.shields.io/badge/Release-1%2E0%2E0--beta%2E1-F05138)](
    https://github.com/feather-framework/feather-validation/releases/tag/1.0.0-beta.1
)

## Features

- Key-value based validation primitives
- Composable rules for string and integer validation
- Async and grouped validation strategies
- Foundation-based rules for URL, email, password, and character sets

## Requirements

![Swift 6.1+](https://img.shields.io/badge/Swift-6%2E1%2B-F05138)
![Platforms: macOS](https://img.shields.io/badge/Platforms-macOS-F05138)

- Swift 6.1+
- Platforms:
  - macOS 10.15+

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

Validation examples are available in:

- `Tests/FeatherValidationTests/FeatherValidationTestSuite.swift`
- `Tests/FeatherValidationFoundationTests/Rule+CharacterSetTestSuite.swift`
- `Tests/FeatherValidationFoundationTests/Rule+EmailTestSuite.swift`
- `Tests/FeatherValidationFoundationTests/Rule+PasswordTestSuite.swift`
- `Tests/FeatherValidationFoundationTests/Rule+URLTestSuite.swift`

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Development

- Build: `swift build`
- Test: `make test`
- Format: `make format`
- Lint: `make lint`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-validation/pulls) are welcome. Please keep changes focused and include tests for new logic.
