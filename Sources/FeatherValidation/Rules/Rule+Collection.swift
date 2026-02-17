//
//  Rule+Collection.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

extension Rule where T: Collection {

    /// Checks if the collection count is greater than or equal to the provided minimum.
    public static func count(
        min: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The collection has fewer elements than expected."
        ) { value in
            guard value.count >= min else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the collection count is less than or equal to the provided maximum.
    public static func count(
        max: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The collection has more elements than expected."
        ) { value in
            guard value.count <= max else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the collection count is equal to the provided expectation.
    public static func count(
        _ expectation: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The collection count does not match the expected value."
        ) { value in
            guard value.count == expectation else {
                throw RuleError.invalid
            }
        }
    }
}
