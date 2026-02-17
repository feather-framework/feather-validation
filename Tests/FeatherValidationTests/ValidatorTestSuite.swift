//
//  CollectionValidatorTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.


import Testing

@testable import FeatherValidation

// TODO: fix uncommented test cases

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

    //    @Test
    //    func mapsIndexedChildFailures() async throws {
    //        let validator = CollectionValidator(
    //            key: "items",
    //            values: ["ok", ""]
    //        ) { _, value in
    //            AsyncValidator {
    //                KeyValueValidator(
    //                    key: "name",
    //                    value: value,
    //                    rules: [.nonempty(message: "empty")]
    //                )
    //                KeyValueValidator(
    //                    key: "bar",
    //                    value: value,
    //                    rules: [
    //                        .length(2)
    //                    ]
    //                )
    //            }
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            print(error.failures)
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "items[1].name")
    //            #expect(error.failures.first?.message == "empty")
    //        }
    //    }
    //
    //    @Test
    //    func mapsIndexedChildFailures2() async throws {
    //        let validator = KeyValueValidator(
    //            key: "items",
    //            value: ["ok", ""],
    //            rules: [
    //                .predicate(message: "empty") { $0.isEmpty }
    //            ]
    //        )
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "items")
    //            #expect(error.failures.first?.message == "empty")
    //        }
    //    }
    //
    //    @Test
    //    func requiredNilFails() async throws {
    //        let validator = CollectionValidator<[String]>(
    //            key: "items",
    //            values: nil,
    //            required: true,
    //            error: "required"
    //        ) { _, value in
    //            KeyValueValidator(
    //                key: "name",
    //                value: value,
    //                rules: [.nonempty()]
    //            )
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "items")
    //            #expect(error.failures.first?.message == "required")
    //        }
    //    }
    //
    //    @Test
    //    func optionalNilPassesWhenNotRequired() async throws {
    //        let validator = CollectionValidator<[String]>(
    //            key: "items",
    //            values: nil,
    //            required: false
    //        ) { _, value in
    //            KeyValueValidator(
    //                key: "name",
    //                value: value,
    //                rules: [.nonempty()]
    //            )
    //        }
    //
    //        try await validator.validate()
    //    }
    //
    //    @Test
    //    func firstInvocationStopsAtFirstFailure() async throws {
    //        let validator = CollectionValidator(
    //            key: "items",
    //            values: ["", ""],
    //            invocation: .first
    //        ) { _, value in
    //            KeyValueValidator(
    //                key: "name",
    //                value: value,
    //                invocation: .all,
    //                rules: [
    //                    .nonempty(message: "empty"),
    //                    .min(length: 2, message: "min"),
    //                ]
    //            )
    //        }
    //
    //        let failures = await validator.failures()
    //        #expect(failures.count == 1)
    //        #expect(failures.first?.key == "items[0].name")
    //    }

    
    // MARK: - multiple fields at once
    
    //    @Test
    //    func passesWhenDependencyIsValid() async throws {
    //        let validator = DependentFieldsValidator(
    //            leftKey: "start",
    //            leftValue: 1,
    //            rightKey: "end",
    //            rightValue: 2,
    //            message: "Start must be <= end."
    //        ) { left, right in
    //            if let left, let right, left > right {
    //                throw RuleError.invalid
    //            }
    //        }
    //
    //        try await validator.validate()
    //    }
    //
    //    @Test
    //    func returnsConfiguredMessageForRuleError() async throws {
    //        let validator = DependentFieldsValidator(
    //            leftKey: "start",
    //            leftValue: 3,
    //            rightKey: "end",
    //            rightValue: 2,
    //            message: "Start must be <= end."
    //        ) { left, right in
    //            if let left, let right, left > right {
    //                throw RuleError.invalid
    //            }
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "start,end")
    //            #expect(error.failures.first?.message == "Start must be <= end.")
    //        }
    //    }
    //
    //    @Test
    //    func supportsCustomFailureKey() async throws {
    //        let validator = DependentFieldsValidator(
    //            leftKey: "password",
    //            leftValue: "secret",
    //            rightKey: "confirmPassword",
    //            rightValue: "secret2",
    //            failureKey: "passwordConfirmation",
    //            message: "Passwords do not match."
    //        ) { left, right in
    //            if left != right {
    //                throw RuleError.invalid
    //            }
    //        }
    //
    //        let failures = await validator.failures()
    //        #expect(failures.count == 1)
    //        #expect(failures.first?.key == "passwordConfirmation")
    //        #expect(failures.first?.message == "Passwords do not match.")
    //    }
    //
    //    @Test
    //    func mapsCustomThrownErrorToFailureMessage() async throws {
//
//    private struct DependencyError: Error, CustomStringConvertible {
//        let description: String
//    }
//
    //        let validator = DependentFieldsValidator(
    //            leftKey: "start",
    //            leftValue: 1,
    //            rightKey: "end",
    //            rightValue: 2
    //        ) { _, _ in
    //            throw DependencyError(description: "dependency error")
    //        }
    //
    //        let failures = await validator.failures()
    //        #expect(failures.count == 1)
    //        #expect(failures.first?.message == "dependency error")
    //    }

}
