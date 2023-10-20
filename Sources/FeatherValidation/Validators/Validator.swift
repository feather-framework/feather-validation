public protocol Validator: Sendable {
    func validate() async throws
}

public extension Validator {
    
    func failures() async -> [Failure] {
        do {
            try await validate()
            return []
        }
        catch ValidatorError.result(let failures) {
            return failures
        }
        catch {
            fatalError("Validators are only allowed to throw `ValidatorError.result([Failure])`. \(error)")
        }
    }

    func isValid() async -> Bool {
        await failures().isEmpty
    }
}
