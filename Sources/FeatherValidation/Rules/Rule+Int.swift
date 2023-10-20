extension Rule where T == Int {

    public static func min(
        _ limit: Int,
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is too small (min: \(limit)."
        ) { value in
            guard value >= limit else {
                throw RuleError.invalid
            }
        }
    }

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
