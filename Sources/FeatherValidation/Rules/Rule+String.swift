//
//  Rule+String.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

extension Rule where T == String {

    /// Check if the value is not empty
    public static func nonempty(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is empty."
        ) { value in
            guard !value.isEmpty else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value length is greater (or equal) than the provided length
    public static func min(
        length: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value is too short (min: \(length) characters)."
        ) { value in
            guard value.count >= length else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value length is smaller (or equal) than the provided length
    public static func max(
        length: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value is too long (max: \(length) characters)."
        ) { value in
            guard value.count <= length else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value length is exactly the provided length.
    public static func length(
        _ expectation: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value does not match the expected length."
        ) { value in
            guard value.count == expectation else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value is not empty after trimming whitespace.
    public static func trimmedNonempty(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is empty."
        ) { value in
            let trimmed = value.drop(while: \.isWhitespace).reversed()
                .drop(while: \.isWhitespace).reversed()
            guard !trimmed.isEmpty else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value starts with a prefix.
    public static func starts(
        with prefix: String,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value does not start with the expected prefix."
        ) { value in
            guard value.hasPrefix(prefix) else {
                throw RuleError.invalid
            }
        }
    }

    /// Check if the value ends with a suffix.
    public static func ends(
        with suffix: String,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value does not end with the expected suffix."
        ) { value in
            guard value.hasSuffix(suffix) else {
                throw RuleError.invalid
            }
        }
    }
}
