//
//  AsyncValidatorTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct AsyncValidatorTestSuite {

    @Test
    func sequentialAggregatesAllFailures() async throws {
        let validator = GroupValidator(
            strategy: .sequential,
            validators: [
                Validator(
                    key: "a",
                    value: "",
                    rules: [.nonempty(message: "empty-a")]
                ),
                Validator(
                    key: "b",
                    value: "",
                    rules: [.nonempty(message: "empty-b")]
                ),
            ]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 2)
            let keys = error.failures.map(\.key)
            #expect(keys.contains("a"))
            #expect(keys.contains("b"))
        }
    }

    @Test
    func parallelAggregatesAllFailures() async throws {
        let validator = GroupValidator(
            strategy: .parallel,
            validators: [
                Validator(
                    key: "a",
                    value: "",
                    rules: [.nonempty(message: "empty-a")]
                ),
                Validator(
                    key: "b",
                    value: "",
                    rules: [.nonempty(message: "empty-b")]
                ),
            ]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 2)
            let keys = error.failures.map(\.key)
            #expect(keys.contains("a"))
            #expect(keys.contains("b"))
        }
    }

    @Test
    func succeedsWhenAllChildValidatorsSucceed() async throws {
        let validator = GroupValidator(
            strategy: .parallel,
            validators: [
                Validator(
                    key: "a",
                    value: "alpha",
                    rules: [.nonempty()]
                ),
                Validator(
                    key: "b",
                    value: "beta",
                    rules: [.nonempty()]
                ),
            ]
        )
        try await validator.validate()
    }
}
