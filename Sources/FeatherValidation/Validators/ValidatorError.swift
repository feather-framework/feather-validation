/// Validator error object
public struct ValidatorError: Error {
    
    /// List of failure objects
    public let failures: [Failure]
}
