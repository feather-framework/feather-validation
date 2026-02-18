//
//  CollectionValidatorTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import Testing

@testable import FeatherValidation

@Suite
struct ValidatorTestSuite {

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

    // MARK: - single values

    @Test
    func invocationFirstStopsOnFirstFailure() async throws {
        let validator = Validator(
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
        let validator = Validator(
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
        let validator = Validator<String>(
            key: "value",
            value: nil,
            required: false,
            rules: [.nonempty()]
        )
        try await validator.validate()
    }

    @Test
    func requiredNilUsesDefaultMessage() async throws {
        let validator = Validator<String>(
            key: "value",
            value: nil,
            required: true,
            rules: [.nonempty()]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message == "The value is required.")
    }

    @Test
    func nonRuleErrorUsesCustomErrorText() async throws {
        struct SampleError: Error {}

        let validator = Validator(
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
        struct DescribedError: Error, CustomStringConvertible {
            let description: String
        }

        let validator = Validator(
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
        struct DescribedError: Error, CustomStringConvertible {
            let description: String
        }

        let validator = Validator(
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
        struct DescribedError: Error, CustomStringConvertible {
            let description: String
        }

        let validator = Validator(
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
        let valid = Validator(
            key: "value",
            value: "ok",
            rules: [.nonempty()]
        )
        #expect(await valid.isValid())
        #expect(await valid.failures().isEmpty)

        let invalid = Validator(
            key: "value",
            value: "",
            rules: [.nonempty(message: "empty")]
        )
        #expect(await invalid.isValid() == false)
        #expect(await invalid.failures().count == 1)
    }

    // MARK: - collections

    @Test
    func passesWhenAllItemsAreValid() async throws {
        let validator = Validator(
            key: "items",
            value: ["a", "b", "c"],
            rules: [
                .init(message: "nonempty") {
                    let nonempty = $0.allSatisfy { !$0.isEmpty }
                    guard nonempty else {
                        throw RuleError.invalid
                    }
                }
            ]
        )

        try await validator.validate()
    }

    @Test
    func mapsCollectionFailureToCollectionKey() async throws {
        let validator = Validator(
            key: "items",
            value: ["ok", ""],
            rules: [
                .init(message: "empty") {
                    guard $0.allSatisfy({ !$0.isEmpty }) else {
                        throw RuleError.invalid
                    }
                }
            ]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.key == "items")
            #expect(error.failures.first?.message == "empty")
        }
    }

    @Test
    func requiredNilCollectionFails() async throws {
        let validator = Validator<[String]>(
            key: "items",
            value: nil,
            required: true,
            error: "required",
            rules: [.count(min: 1)]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.key == "items")
            #expect(error.failures.first?.message == "required")
        }
    }

    @Test
    func optionalNilCollectionPassesWhenNotRequired() async throws {
        let validator = Validator<[String]>(
            key: "items",
            value: nil,
            required: false,
            rules: [.count(min: 1)]
        )

        try await validator.validate()
    }

    @Test
    func collectionInvocationFirstStopsAtFirstFailure() async throws {
        let validator = Validator(
            key: "items",
            value: [String](),
            invocation: .first,
            rules: [
                .count(min: 1, message: "first"),
                .count(min: 2, message: "second"),
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message == "first")
    }

    // MARK: - multiple fields at once

    @Test
    func passesWhenDependencyIsValid() async throws {
        let validator = Validator(
            key: "start,end",
            value: (1 as Int?, 2 as Int?),
            rules: [
                .init(message: "Start must be <= end.") { start, end in
                    if let start, let end, start > end {
                        throw RuleError.invalid
                    }
                }
            ]
        )

        try await validator.validate()
    }

    @Test
    func returnsConfiguredMessageForRuleError() async throws {
        let validator = Validator(
            key: "start,end",
            value: (3 as Int?, 2 as Int?),
            rules: [
                .init(message: "Start must be <= end.") { start, end in
                    if let start, let end, start > end {
                        throw RuleError.invalid
                    }
                }
            ]
        )

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.key == "start,end")
            #expect(error.failures.first?.message == "Start must be <= end.")
        }
    }

    @Test
    func supportsCustomFailureKey() async throws {
        let validator = Validator(
            key: "passwordConfirmation",
            value: ("secret" as String?, "secret2" as String?),
            rules: [
                .init(message: "Passwords do not match.") { left, right in
                    if left != right {
                        throw RuleError.invalid
                    }
                }
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.key == "passwordConfirmation")
        #expect(failures.first?.message == "Passwords do not match.")
    }

    @Test
    func mapsCustomThrownErrorToFailureMessage() async throws {
        struct DependencyError: Error, CustomStringConvertible {
            let description: String
        }

        let validator = Validator(
            key: "start,end",
            value: (1 as Int?, 2 as Int?),
            rules: [
                .init(message: "unused") { _, _ in
                    throw DependencyError(description: "dependency error")
                }
            ]
        )

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message == "dependency error")
    }
}
