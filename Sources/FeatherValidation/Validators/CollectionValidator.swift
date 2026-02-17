//
//  CollectionValidator.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

/// Validates each element in a collection with a child validator.
public struct CollectionValidator<C: Collection & Sendable>: Validator where C.Element: Sendable {

    /// Rule invocation method for collection elements.
    public enum Invocation: Sendable {
        /// Stop after the first failure.
        case first
        /// Evaluate all elements and collect all failures.
        case all
    }

    /// Parent field key used to prefix child failure keys.
    public let key: String

    /// Collection to validate.
    public let values: C?

    /// Indicates whether `values` must be present.
    public let required: Bool

    /// Optional custom error message used when a required value is missing.
    public let error: String?

    /// Rule invocation method.
    public let invocation: Invocation

    let validator: @Sendable (_ index: Int, _ value: C.Element) -> Validator

    /// Creates a collection validator.
    public init(
        key: String,
        values: C?,
        required: Bool = true,
        error: String? = nil,
        invocation: Invocation = .all,
        validator: @escaping @Sendable (_ index: Int, _ value: C.Element) -> Validator
    ) {
        self.key = key
        self.values = values
        self.required = required
        self.error = error
        self.invocation = invocation
        self.validator = validator
    }

    /// Validates the collection.
    public func validate() async throws(ValidatorError) {
        guard let values = values else {
            if required {
                let message = error ?? "The value is required."
                throw ValidatorError(
                    failures: [
                        .init(key: key, message: message)
                    ]
                )
            }
            return
        }

        var failures: [Failure] = []

        for (index, value) in values.enumerated() {
            let childFailures = await validator(index, value).failures()
            let prefix = key.isEmpty ? "[\(index)]" : "\(key)[\(index)]"

            let mapped: [Failure] = childFailures.map { failure in
                let mappedKey: String
                if failure.key.isEmpty {
                    mappedKey = prefix
                }
                else {
                    mappedKey = "\(prefix).\(failure.key)"
                }
                return .init(
                    key: mappedKey,
                    message: failure.message
                )
            }

            switch invocation {
            case .first:
                if let firstFailure = mapped.first {
                    failures.append(firstFailure)
                    break
                }
            case .all:
                failures.append(contentsOf: mapped)
            }

            if invocation == .first, !failures.isEmpty {
                break
            }
        }

        guard failures.isEmpty else {
            throw ValidatorError(failures: failures)
        }
    }
}
