//
//  KeyValueValidator.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

/// Key value object validator
public struct Validator<T: Sendable>: Validation {

    /// Rule invocation method
    public enum Invocation: Sendable {
        /// Stop after the first failed rule
        case first
        /// Evaluates all the rules
        case all
    }

    /// The key to uniquely identify a given object
    public let key: String

    /// The value of a given object
    public let value: T?

    /// Indicates whether `value` must be present.
    public let required: Bool

    /// Optional custom error message for required-value failure.
    public let error: String?

    /// Rule invocation method
    public let invocation: Invocation

    /// List of validation rules
    public let rules: [Rule<T>]

    /// Creates a new KeyValueValidator object
    /// - Parameters:
    ///   - key: The field key associated with this validation.
    ///   - value: The value to validate.
    ///   - required: If `true`, missing values produce a failure.
    ///   - error: Optional custom message used when a required value is missing.
    ///   - invocation: The rule invocation strategy.
    ///   - rules: The rules to evaluate.
    public init(
        key: String,
        value: T?,
        required: Bool = true,
        error: String? = nil,
        invocation: Invocation = .first,
        rules: [Rule<T>]
    ) {
        self.key = key
        self.value = value
        self.required = required
        self.error = error
        self.invocation = invocation
        self.rules = rules
    }

    /// Validates the given object
    public func validate() async throws(ValidationError) {
        var failures: [Failure] = []

        if let value = value {
            for rule in rules {
                if invocation == .first, !failures.isEmpty {
                    break
                }
                do {
                    try await rule.validate(value)
                }
                catch RuleError.invalid {
                    failures.append(
                        .init(
                            key: key,
                            message: rule.message
                        )
                    )
                }
                catch {
                    failures.append(
                        .init(
                            key: key,
                            message: "\(error)"
                        )
                    )
                }
            }
        }
        else {
            if required {
                let message = error ?? "The value is required."
                failures.append(
                    .init(
                        key: key,
                        message: message
                    )
                )
            }
        }

        guard failures.isEmpty else {
            throw ValidationError(failures: failures)
        }
    }
}
