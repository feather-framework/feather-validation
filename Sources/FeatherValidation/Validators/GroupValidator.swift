/// Group validator
public struct GroupValidator: Validator {

    /// Group validation strategy
    public enum Strategy: Sendable {
        
        /// Sequential execution strategy
        case sequential
        
        /// Parallel execution strategy
        case parallel
    }

    let strategy: Strategy
    var validators: [Validator]

    /// Creates a new GroupValidator
    public init(
        strategy: Strategy = .sequential,
        _ validators: [Validator]
    ) {
        self.strategy = strategy
        self.validators = validators
    }

    /// Creates a new GroupValidator
    public init(
        strategy: Strategy = .sequential,
        @ValidatorBuilder _ validators: () -> [Validator]
    ) {
        self.strategy = strategy
        self.validators = validators()
    }
}

public extension GroupValidator {

    /// Validates the object
    func validate() async throws {
        switch strategy {
        case .sequential:
            try await sequentialExecution()
        case .parallel:
            try await parallelExecution()
        }
    }
}

private extension GroupValidator {

    func parallelExecution() async throws {
        let result = await withTaskGroup(
            of: [Failure].self
        ) { group in
            for validator in validators {
                group.addTask {
                    await validator.failures()
                }
            }
            var result: [Failure] = []
            for await item in group {
                result.append(contentsOf: item)
            }
            return result
        }
        guard result.isEmpty else {
            throw ValidatorError(failures: result)
        }
    }

    func sequentialExecution() async throws {
        var result: [Failure] = []
        for validator in validators {
            let failures = await validator.failures()
            result.append(contentsOf: failures)
        }
        guard result.isEmpty else {
            throw ValidatorError(failures: result)
        }
    }
}
