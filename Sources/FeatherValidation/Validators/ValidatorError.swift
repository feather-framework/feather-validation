/// Validator error object
public struct ValidatorError: Error {

    public init(failures: [Failure]) {
        self.failures = failures
    }

    /// List of failure objects
    public let failures: [Failure]
}
