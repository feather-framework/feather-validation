extension Rule where T == String {

    public static func required(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is required."
        ) { value in
            guard !value.isEmpty else {
                throw RuleError.invalid
            }
        }
    }

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
