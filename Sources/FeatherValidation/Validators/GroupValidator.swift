public struct GroupValidator: Validator {

    public enum Strategy: Sendable {
        case sequential
        case parallel
    }

    let strategy: Strategy
    var validators: [Validator]

    public init(
        strategy: Strategy = .sequential,
        _ validators: [Validator]
    ) {
        self.strategy = strategy
        self.validators = validators
    }

    public init(
        strategy: Strategy = .sequential,
        @ValidatorBuilder _ validators: () -> [Validator]
    ) {
        self.strategy = strategy
        self.validators = validators()
    }
}

public extension GroupValidator {

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
