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
}
