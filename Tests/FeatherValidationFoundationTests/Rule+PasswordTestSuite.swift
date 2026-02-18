//
//  Rule+PasswordTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_PasswordTestSuite {

    @Test
    func uppercase() async throws {
        let v = Validator(
            key: "password",
            value: "Abcdefg",
            rules: [
                .password(rule: .uppercase)
            ]
        )
        try await v.validate()
    }

    @Test
    func uppercaseFail() async throws {
        let v = Validator(
            key: "password",
            value: "abcdefg",
            rules: [
                .password(rule: .uppercase)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

    @Test
    func lowercase() async throws {
        let v = Validator(
            key: "password",
            value: "Abcdefg",
            rules: [
                .password(rule: .lowercase)
            ]
        )
        try await v.validate()
    }

    @Test
    func lowercaseFail() async throws {
        let v = Validator(
            key: "password",
            value: "ABCDEFG",
            rules: [
                .password(rule: .lowercase)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

    @Test
    func digit() async throws {
        let v = Validator(
            key: "password",
            value: "Abcdefg1",
            rules: [
                .password(rule: .digit)
            ]
        )
        try await v.validate()
    }

    @Test
    func digitFail() async throws {
        let v = Validator(
            key: "password",
            value: "ABCDEFG",
            rules: [
                .password(rule: .digit)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

    @Test
    func passwordRuleUsesDefaultMessageOnFailure() async throws {
        let v = Validator(
            key: "password",
            value: "abcdefg",
            rules: [
                .password(rule: .uppercase)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "The value is an invalid password.")
        }
    }

    @Test
    func combined() async throws {
        let v = Validator(
            key: "password",
            value: "Abcdefg1",
            rules: [
                .password(rule: .combined)
            ]
        )
        try await v.validate()
    }

    @Test
    func combinedFail() async throws {
        let v = Validator(
            key: "password",
            value: "Aaavkjn.-",
            rules: [
                .password(rule: .combined)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

    @Test
    func customMessageOnPasswordFailure() async throws {
        let v = Validator(
            key: "password",
            value: "abcdefg",
            rules: [
                .password(rule: .uppercase, message: "need uppercase")
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "need uppercase")
        }
    }

    @Test
    func defaultPasswordRuleIsDigit() async throws {
        let v = Validator(
            key: "password",
            value: "abcDEF",
            rules: [
                .password()
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

}
