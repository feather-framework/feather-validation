//
//  GroupValidatorTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import Testing

@testable import FeatherValidation

@Suite
struct GroupValidatorTestSuite {

    @Test
    func basicExample() async throws {
        let key = "foo"
        let value = ""

        let v = GroupValidator {
            Validator(
                key: key,
                value: value,
                invocation: .all,
                rules: [
                    .nonempty(message: "empty"),
                    .min(length: 2, message: "min"),
                    .max(length: 32),
                    .init(
                        message: "ouch",
                        { _ in
                            throw RuleError.invalid
                        }
                    ),
                ]
            )
        }

        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 3)
            for failure in error.failures {
                #expect(failure.key == key)
            }
            let messages = error.failures.map { $0.message }
            #expect(messages.contains("empty"))
            #expect(messages.contains("min"))
            #expect(messages.contains("ouch"))
        }
    }

    @Test
    func nilExample() async throws {
        let key = "foo"
        let value: String? = nil

        let v = GroupValidator {
            Validator(
                key: key,
                value: value,
                required: true,
                error: "req",
                invocation: .all,
                rules: [
                    .min(length: 2, message: "min")
                ]
            )
        }

        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)

            let messages = error.failures.map { $0.message }
            #expect(messages.contains("req"))
        }
    }

    @Test
    func optionalPresentValueStillRunsRules() async throws {
        let key = "foo"
        let value: String? = ""

        let v = GroupValidator {
            Validator(
                key: key,
                value: value,
                invocation: .all,
                rules: [
                    .nonempty(message: "empty"),
                    .min(length: 2, message: "min"),
                    .max(length: 32),
                    .init(
                        message: "ouch",
                        { _ in
                            throw RuleError.invalid
                        }
                    ),
                ]
            )
        }

        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 3)
            for failure in error.failures {
                #expect(failure.key == key)
            }
            let messages = error.failures.map { $0.message }
            #expect(messages.contains("empty"))
            #expect(messages.contains("min"))
            #expect(messages.contains("ouch"))
        }
    }

    @Test
    func nil2Example() async throws {
        let key = "foo"
        let value: String? = nil

        let v = GroupValidator {
            if let value = value {
                Validator(
                    key: key,
                    value: value,
                    required: true,
                    error: "req",
                    invocation: .all,
                    rules: [
                        .min(length: 2, message: "min")
                    ]
                )
            }
            else {
                Failure(key: "title", message: "req")
            }
        }

        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)

            let messages = error.failures.map { $0.message }
            #expect(messages.contains("req"))
        }
    }

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

    @Test
    func groupValidatorOptionalBranchUsesEmptyValidator() async throws {
        let include = false
        let validator = GroupValidator {
            if include {
                Validator(
                    key: "value",
                    value: "",
                    rules: [.nonempty()]
                )
            }
        }
        try await validator.validate()
    }

    @Test
    func groupValidatorEitherFirstBranch() async throws {
        let chooseFirst = true
        let validator = GroupValidator {
            if chooseFirst {
                Validator(
                    key: "value",
                    value: "",
                    rules: [.nonempty(message: "first-branch")]
                )
            }
            else {
                Validator(
                    key: "value",
                    value: "ok",
                    rules: [.nonempty()]
                )
            }
        }

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "first-branch")
        }
    }

    @Test
    func groupValidatorEitherSecondBranch() async throws {
        let chooseFirst = false
        let validator = GroupValidator {
            if chooseFirst {
                Validator(
                    key: "value",
                    value: "ok",
                    rules: [.nonempty()]
                )
            }
            else {
                Validator(
                    key: "value",
                    value: "",
                    rules: [.nonempty(message: "second-branch")]
                )
            }
        }

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "second-branch")
        }
    }
}
