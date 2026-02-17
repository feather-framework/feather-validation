/// A single validation failure entry.
public struct Failure {

    /// The field key associated with the failure.
    public let key: String

    /// The human-readable failure message.
    public let message: String

    /// Creates a new failure value.
    /// - Parameters:
    ///   - key: The field key associated with the failure.
    ///   - message: The human-readable failure message.
    public init(key: String, message: String) {
        self.key = key
        self.message = message
    }
}

extension Failure: Validator {

    /// Throws a `ValidatorError` containing this single failure.
    public func validate() async throws {
        throw ValidatorError(failures: [self])
    }
}
