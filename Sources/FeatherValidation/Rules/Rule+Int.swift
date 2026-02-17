//
//  Rule+Int.swift
//  feather-validation
//
//  Created by Binary Birds on 2023. 10. 21.

extension Rule where T == Int {

    /// Check if the value is greater (or equal) than the provided limit
    public static func min(
        _ limit: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is too small (min: \(limit))."
        ) { value in
            guard value >= limit else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is smaller (or equal) than the provided limit
    public static func max(
        _ limit: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is too large (max: \(limit))."
        ) { value in
            guard value <= limit else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is equal to the expectation
    public static func equals(
        _ expectation: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value does not match the expected number."
        ) { value in
            guard value == expectation else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is in a closed range.
    public static func range(
        _ range: ClosedRange<Int>,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value is out of the expected range."
        ) { value in
            guard range.contains(value) else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is positive.
    public static func positive(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value must be positive."
        ) { value in
            guard value > 0 else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is non-negative.
    public static func nonNegative(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value must be non-negative."
        ) { value in
            guard value >= 0 else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is negative.
    public static func negative(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value must be negative."
        ) { value in
            guard value < 0 else {
                throw RuleError.invalid
            }
        }
    }

}
