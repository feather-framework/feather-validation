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
}
