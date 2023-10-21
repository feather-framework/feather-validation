/// The validator protocol
public protocol Validator: Sendable {

    /// Validates a given
    func validate() async throws
}

public extension Validator {

    /// Returns the validated Faulure objects
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

    /// Check if a validator is valid or not
    func isValid() async -> Bool {
        await failures().isEmpty
    }
}
