//
//  DependentFieldsValidatorTestSuite.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

import FeatherValidation
import Testing

private struct DependencyError: Error, CustomStringConvertible {
    let description: String
}

@Suite
struct DependentFieldsValidatorTestSuite {

    @Test
    func passesWhenDependencyIsValid() async throws {
        let validator = DependentFieldsValidator(
            leftKey: "start",
            leftValue: 1,
            rightKey: "end",
            rightValue: 2,
            message: "Start must be <= end."
        ) { left, right in
            if let left, let right, left > right {
                throw RuleError.invalid
            }
        }

        try await validator.validate()
    }

    @Test
    func returnsConfiguredMessageForRuleError() async throws {
        let validator = DependentFieldsValidator(
            leftKey: "start",
            leftValue: 3,
            rightKey: "end",
            rightValue: 2,
            message: "Start must be <= end."
        ) { left, right in
            if let left, let right, left > right {
                throw RuleError.invalid
            }
        }

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
        let validator = DependentFieldsValidator(
            leftKey: "password",
            leftValue: "secret",
            rightKey: "confirmPassword",
            rightValue: "secret2",
            failureKey: "passwordConfirmation",
            message: "Passwords do not match."
        ) { left, right in
            if left != right {
                throw RuleError.invalid
            }
        }

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.key == "passwordConfirmation")
        #expect(failures.first?.message == "Passwords do not match.")
    }

    @Test
    func mapsCustomThrownErrorToFailureMessage() async throws {
        let validator = DependentFieldsValidator(
            leftKey: "start",
            leftValue: 1,
            rightKey: "end",
            rightValue: 2
        ) { _, _ in
            throw DependencyError(description: "dependency error")
        }

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.message == "dependency error")
    }
}
