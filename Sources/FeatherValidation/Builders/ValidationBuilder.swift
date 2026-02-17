//
//  ValidatorBuilder.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

/// DSL syntax for Validator objects
@resultBuilder
public enum ValidationBuilder {

    /// Builds a validator from the given components.
    /// - Parameter components: The validator components.
    /// - Returns: The composed validator.
    public static func buildBlock(
        _ components: Validation...
    ) -> Validation {
        GroupValidator(validators: components)
    }

    /// Builds a validator from an optional validator component.
    /// - Parameter component: An optional validator component.
    /// - Returns: The provided validator or an `EmptyValidator` when `nil`.
    public static func buildOptional(
        _ component: Validation?
    ) -> Validation {
        component ?? EmptyValidator()
    }

    /// Builds a validator from the first branch of a conditional expression.
    /// - Parameter component: The validator produced by the first branch.
    /// - Returns: The same validator.
    public static func buildEither(
        first component: Validation
    ) -> Validation {
        component
    }

    /// Builds a validator from the second branch of a conditional expression.
    /// - Parameter component: The validator produced by the second branch.
    /// - Returns: The same validator.
    public static func buildEither(
        second component: Validation
    ) -> Validation {
        component
    }
}
