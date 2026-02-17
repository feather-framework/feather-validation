extension Rule where T: Comparable {

    /// Checks if the value is less than the expected value.
    public static func lessThan(
        _ expectation: T,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value must be less than the expected value."
        ) { value in
            guard value < expectation else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the value is less than or equal to the expected value.
    public static func lessThanOrEqual(
        _ expectation: T,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value must be less than or equal to the expected value."
        ) { value in
            guard value <= expectation else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the value is greater than the expected value.
    public static func greaterThan(
        _ expectation: T,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value must be greater than the expected value."
        ) { value in
            guard value > expectation else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the value is greater than or equal to the expected value.
    public static func greaterThanOrEqual(
        _ expectation: T,
        message: String? = nil
    ) -> Self {
        .init(
            message: message
                ?? "The value must be greater than or equal to the expected value."
        ) { value in
            guard value >= expectation else {
                throw RuleError.invalid
            }
        }
    }

    /// Checks if the value is in the expected closed range.
    public static func between(
        _ range: ClosedRange<T>,
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
}
