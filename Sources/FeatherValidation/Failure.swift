// Failure object
public struct Failure {

    // key
    public let key: String

    // message
    public let message: String

    public init(key: String, message: String) {
        self.key = key
        self.message = message
    }
}

extension Failure: Validator {

    public func validate() async throws {
        throw ValidatorError(failures: [self])
    }
}
