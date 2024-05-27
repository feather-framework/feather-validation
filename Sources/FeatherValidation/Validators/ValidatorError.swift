/// Validator error object
public struct ValidatorError: Error {

    /// Initializes a new `ValidatorError` with a list of failures.
    /// - Parameter failures: An array of `Failure` objects.
    public init(failures: [Failure]) {
        self.failures = failures
    }

    /// List of failure objects
    public let failures: [Failure]
}
