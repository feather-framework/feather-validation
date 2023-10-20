public struct KeyValueValidator<T: Sendable>: Validator {
    
    /// Rule invocation
    public enum Invocation: Sendable {
        /// stop after the first failed rule
        case first
        /// evaluate all the rules
        case all
    }

    public let key: String
    public let value: T
    public let invocation: Invocation
    public let rules: [Rule<T>]

    public init(
        key: String,
        value: T,
        invocation: Invocation = .first,
        rules: [Rule<T>]
    ) {
        self.key = key
        self.value = value
        self.invocation = invocation
        self.rules = rules
    }

    public func validate() async throws {
        var failures: [Failure] = []
        for rule in rules {
            if invocation == .first, !failures.isEmpty {
                break
            }
            do {
                try await rule.validate(value)
            }
            catch RuleError.invalid {
                failures.append(
                    .init(
                        key: key,
                        message: rule.message
                    )
                )
            }
            catch {
                failures.append(
                    .init(
                        key: key,
                        message: "\(error)"
                    )
                )
            }
        }
        guard failures.isEmpty else {
            throw ValidatorError.result(failures)
        }
    }
}
