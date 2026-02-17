//
//  GroupValidator.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

/// Groups a collection of validators using `ValidatorBuilder`.
public struct GroupValidator: Validator {

    let validator: Validator

    /// Creates a group validator from a validator builder closure.
    /// - Parameter validator: Builder closure that returns a composed validator.
    public init(
        @ValidatorBuilder _ validator: () -> Validator
    ) {
        self.validator = validator()
    }

    /// Validates the composed validator tree.
    public func validate() async throws(ValidatorError) {
        try await validator.validate()
    }
}
