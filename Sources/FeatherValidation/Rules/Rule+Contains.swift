//
//  Rule+Contains.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2023. 10. 21.

extension Rule where T: Equatable {

    /// Checks if the value is part of the provided options array
    public static func contains(
        options: [T],
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value is not matching the available options."
        ) { value in
            guard options.contains(value) else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the value is not part of the provided options array.
    public static func notContains(
        options: [T],
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value matches a forbidden option."
        ) { value in
            guard !options.contains(value) else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the value is not equal to the expected value.
    public static func notEquals(
        _ expectation: T,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value matches a forbidden value."
        ) { value in
            guard value != expectation else {
                throw RuleError.invalid
            }
        }
    }
}
