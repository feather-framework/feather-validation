//
//  AsyncValidator.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

/// Group validator
public struct GroupValidator: Validation {

    /// Group validation strategy
    public enum Strategy: Sendable {

        /// Sequential execution strategy
        case sequential

        /// Parallel execution strategy
        case parallel
    }

    var strategy: Strategy
    var validators: [Validation]

    /// Creates a new AsyncValidator
    public init(
        strategy: Strategy = .sequential,
        validators: [Validation]
    ) {
        self.strategy = strategy
        self.validators = validators
    }

    public init(
        strategy: Strategy = .sequential,
        @ValidationBuilder _ builder: () -> Validation
    ) {
        self.strategy = strategy
        self.validators = [builder()]
    }
}

public extension GroupValidator {

    /// Validates the object
    func validate() async throws(ValidationError) {
        switch strategy {
        case .sequential:
            try await sequentialExecution()
        case .parallel:
            try await parallelExecution()
        }
    }
}

private extension GroupValidator {

    func parallelExecution() async throws(ValidationError) {
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
            throw ValidationError(failures: result)
        }
    }

    func sequentialExecution() async throws(ValidationError) {
        var result: [Failure] = []
        for validator in validators {
            let failures = await validator.failures()
            result.append(contentsOf: failures)
        }
        guard result.isEmpty else {
            throw ValidationError(failures: result)
        }
    }
}
