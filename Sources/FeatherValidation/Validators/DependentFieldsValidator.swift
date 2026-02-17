//
//  DependentFieldsValidator.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

/// Validates dependent fields using a cross-field validation closure.
public struct DependentFieldsValidator<
    Left: Sendable,
    Right: Sendable
>: Validator {

    /// The left field key.
    public let leftKey: String

    /// The left field value.
    public let leftValue: Left?

    /// The right field key.
    public let rightKey: String

    /// The right field value.
    public let rightValue: Right?

    /// The failure key used when the dependency check fails.
    public let failureKey: String

    /// The message used when the dependency check fails with `RuleError.invalid`.
    public let message: String

    let block: @Sendable (_ left: Left?, _ right: Right?) async throws -> Void

    /// Creates a dependent-fields validator.
    public init(
        leftKey: String,
        leftValue: Left?,
        rightKey: String,
        rightValue: Right?,
        failureKey: String? = nil,
        message: String = "The dependent fields are invalid.",
        _ block:
            @escaping @Sendable (
                _ left: Left?,
                _ right: Right?
            ) async throws -> Void
    ) {
        self.leftKey = leftKey
        self.leftValue = leftValue
        self.rightKey = rightKey
        self.rightValue = rightValue
        self.failureKey = failureKey ?? "\(leftKey),\(rightKey)"
        self.message = message
        self.block = block
    }

    /// Validates field dependency.
    public func validate() async throws(ValidatorError) {
        do {
            try await block(leftValue, rightValue)
        }
        catch RuleError.invalid {
            throw ValidatorError(
                failures: [
                    .init(
                        key: failureKey,
                        message: message
                    )
                ]
            )
        }
        catch {
            throw ValidatorError(
                failures: [
                    .init(
                        key: failureKey,
                        message: "\(error)"
                    )
                ]
            )
        }
    }
}
