//
//  Rule+EmailTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_EmailTestSuite {

    @Test
    func validEmail() async throws {
        let v = Validator(
            key: "email",
            value: "mail.tib@gmail.com",
            rules: [
                .email()
            ]
        )
        try await v.validate()
    }

    @Test
    func invalidEmail() async throws {
        let v = Validator(
            key: "email",
            value: "@gmail.com",
            rules: [
                .email(rule: .international)
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
    func invalidEmailUsesDefaultMessage() async throws {
        let v = Validator(
            key: "email",
            value: "broken",
            rules: [
                .email()
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(
                error.failures.first?.message
                    == "The value is an invalid email."
            )
        }
    }

    @Test
    func validInternationalEmail() async throws {
        let v = Validator(
            key: "email",
            value: "árvíztűrő@example.com",
            rules: [
                .email(rule: .international)
            ]
        )
        try await v.validate()
    }

    @Test
    func regularEmailRejectsTooLongLocalPart() async throws {
        let local = String(repeating: "a", count: 65)
        let v = Validator(
            key: "email",
            value: "\(local)@example.com",
            rules: [
                .email(rule: .regular)
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
    func defaultRuleBehavesAsRegular() async throws {
        let v = Validator(
            key: "email",
            value: "árvíztűrő@example.com",
            rules: [
                .email()
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
    func regularEmailRejectsTooLongAddress() async throws {
        let local = String(repeating: "a", count: 64)
        let domainLabel = String(repeating: "b", count: 252)
        let v = Validator(
            key: "email",
            value: "\(local)@\(domainLabel).com",
            rules: [
                .email(rule: .regular)
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
    func customMessageOnEmailFailure() async throws {
        let v = Validator(
            key: "email",
            value: "broken",
            rules: [
                .email(message: "bad email")
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "bad email")
        }
    }

}
