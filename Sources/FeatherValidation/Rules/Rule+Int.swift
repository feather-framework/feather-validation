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

}
