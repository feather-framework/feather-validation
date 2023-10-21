/// Key value object validator
public struct KeyValueValidator<T: Sendable>: Validator {

    /// Rule invocation method
    public enum Invocation: Sendable {
        /// Stop after the first failed rule
        case first
        /// Evaluates all the rules
        case all
    }

    /// The key to uniquely identify a given object
    public let key: String
    
    /// The value of a given object
    public let value: T
    
    /// Rule invocation method
    public let invocation: Invocation
    
    /// List of validation rules
    public let rules: [Rule<T>]

    /// Creates a new KeyValueValidator object
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

    /// Validates the given object
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
            throw ValidatorError(failures: failures)
        }
    }
}
