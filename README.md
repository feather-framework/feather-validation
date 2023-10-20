# Feather Validation

A generic purpose validation library for server side Swift projects.

## Install

Add the repository as a dependency:

```swift
.package(url: "https://github.com/feather-framework/feather-validation", from: "1.0.0"),
```

Add `FeatherValidation` to the target dependencies:

```swift
.product(name: "FeatherValidation", package: "feather-validation"),
```

Update the packages and you are ready.

## Usage example

Basic example

```swift
import FeatherValidation

// ...

let key = "foo"
let value = ""
let v = GroupValidator(strategy: .parallel) {
    KeyValueValidator(
        key: key,
        value: value,
        invocation: .all,
        rules: [
            .required(),
            .min(length: 2),
            .max(length: 32),
            .init(message: "Custom validation error", { _ in
                throw RuleError.invalid
            }),
        ]
    )
}

do {
    try await v.validate()
}
catch let error as ValidatorError {
    for failure in error.failures {
        print(failure.key, failure.message)
    }
}
catch {
    print("\(error)")
}
```
