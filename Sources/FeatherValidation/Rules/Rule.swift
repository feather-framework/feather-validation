/// Validation rule
public struct Rule<T: Sendable>: Sendable {
    
    /// The error message if the rule failes during the validation process
    public let message: String
    
    /// The block to execute during the validation process
    public let block: @Sendable (_ value: T) async throws -> Void

    /// Creates a new Rule object
    public init(
        message: String,
        _ block: @Sendable @escaping (_ value: T) async throws -> Void
    ) {
        self.message = message
        self.block = block
    }

    /// Validates the rule using the given value
    public func validate(_ value: T) async throws {
        try await block(value)
    }
}
