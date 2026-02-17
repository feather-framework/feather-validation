//
//  FeatherValidationCoreTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

private struct SampleError: Error {}
private struct DescribedError: Error, CustomStringConvertible {
    let description: String
}

@Suite
struct FeatherValidationCoreTestSuite {

    @Test
    func intMinRule() async throws {
        try await Rule<Int>.min(10).validate(10)
        do {
            try await Rule<Int>.min(10).validate(9)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func intMaxRule() async throws {
        try await Rule<Int>.max(10).validate(10)
        do {
            try await Rule<Int>.max(10).validate(11)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func intEqualsRule() async throws {
        try await Rule<Int>.equals(42).validate(42)
        do {
            try await Rule<Int>.equals(42).validate(41)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func stringLengthRule() async throws {
        try await Rule<String>.length(3).validate("abc")
        do {
            try await Rule<String>.length(3).validate("ab")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func containsRule() async throws {
        try await Rule<String>.contains(options: ["a", "b"]).validate("a")
        do {
            try await Rule<String>.contains(options: ["a", "b"]).validate("c")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func invocationFirstStopsOnFirstFailure() async throws {
        let validator = KeyValueValidator(
            key: "value",
            value: "",
            invocation: .first,
            rules: [
                .nonempty(message: "first"),
                .min(length: 2, message: "second"),
            ]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "first")
        }
    }

    @Test
    func invocationAllCollectsFailures() async throws {
        let validator = KeyValueValidator(
            key: "value",
            value: "",
            invocation: .all,
            rules: [
                .nonempty(message: "first"),
                .min(length: 2, message: "second"),
            ]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 2)
            let messages = error.failures.map(\.message)
            #expect(messages.contains("first"))
            #expect(messages.contains("second"))
        }
    }

    @Test
    func nilOptionalNotRequiredPasses() async throws {
        let validator = KeyValueValidator<String>(
            key: "value",
            value: nil,
            required: false,
            rules: [.nonempty()]
        )
        try await validator.validate()
    }

    @Test
    func nonRuleErrorUsesCustomErrorText() async throws {
        let validator = KeyValueValidator(
            key: "value",
            value: "abc",
            rules: [
                .init(message: "irrelevant") { _ in
                    throw SampleError()
                }
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message.contains("SampleError") == true)
    }

    @Test
    func nonRuleErrorUsesThrownErrorDescriptionExactly() async throws {
        let validator = KeyValueValidator(
            key: "value",
            value: "abc",
            rules: [
                .init(message: "should-not-be-used") { _ in
                    throw DescribedError(description: "boom")
                }
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message == "boom")
    }

    @Test
    func invocationAllCollectsRuleAndNonRuleFailures() async throws {
        let validator = KeyValueValidator(
            key: "value",
            value: "",
            invocation: .all,
            rules: [
                .nonempty(message: "empty"),
                .init(message: "should-not-be-used") { _ in
                    throw DescribedError(description: "boom")
                },
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 2)
        let messages = failures.map(\.message)
        #expect(messages.contains("empty"))
        #expect(messages.contains("boom"))
        #expect(messages.contains("should-not-be-used") == false)
    }

    @Test
    func invocationFirstStopsAfterNonRuleFailure() async throws {
        let validator = KeyValueValidator(
            key: "value",
            value: "abc",
            invocation: .first,
            rules: [
                .init(message: "ignored") { _ in
                    throw DescribedError(description: "boom")
                },
                .init(message: "second-rule-should-not-run") { _ in
                    throw RuleError.invalid
                },
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message == "boom")
    }

    @Test
    func validatorFailuresAndIsValid() async throws {
        let valid = KeyValueValidator(
            key: "value",
            value: "ok",
            rules: [.nonempty()]
        )
        #expect(await valid.isValid())
        #expect(await valid.failures().isEmpty)

        let invalid = KeyValueValidator(
            key: "value",
            value: "",
            rules: [.nonempty(message: "empty")]
        )
        #expect(await invalid.isValid() == false)
        #expect(await invalid.failures().count == 1)
    }

    @Test
    func failureValidatorThrowsItself() async throws {
        let failure = Failure(key: "title", message: "missing")
        do {
            try await failure.validate()
            Issue.record("Failure validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.key == "title")
            #expect(error.failures.first?.message == "missing")
        }
    }

    @Test
    func groupValidatorOptionalBranchUsesEmptyValidator() async throws {
        let include = false
        let validator = GroupValidator {
            if include {
                KeyValueValidator(
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
                KeyValueValidator(
                    key: "value",
                    value: "",
                    rules: [.nonempty(message: "first-branch")]
                )
            }
            else {
                KeyValueValidator(
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
                KeyValueValidator(
                    key: "value",
                    value: "ok",
                    rules: [.nonempty()]
                )
            }
            else {
                KeyValueValidator(
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
