/// The validator protocol
public protocol Validator: Sendable {

    /// Performs validation and throws on failure.
    func validate() async throws
}

public extension Validator {

    /// Returns all failures produced by this validator.
    /// - Returns: An empty array if validation succeeds, otherwise the collected failures.
    func failures() async -> [Failure] {
        do {
            try await validate()
            return []
        }
        catch let error as ValidatorError {
            return error.failures
        }
        catch {
            fatalError(
                "Validators are only allowed to throw `ValidatorError.result([Failure])`. \(error)"
            )
        }
    }

    /// Indicates whether validation succeeds.
    /// - Returns: `true` when no failures are produced.
    func isValid() async -> Bool {
        await failures().isEmpty
    }
}
