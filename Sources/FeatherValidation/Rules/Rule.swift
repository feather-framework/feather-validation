public struct Rule<T: Sendable>: Sendable {
    public let message: String
    public let block: @Sendable (_ value: T) async throws -> Void

    public init(
        message: String,
        _ block: @Sendable @escaping (_ value: T) async throws -> Void
    ) {
        self.message = message
        self.block = block
    }

    public func validate(_ value: T) async throws {
        try await block(value)
    }
}
