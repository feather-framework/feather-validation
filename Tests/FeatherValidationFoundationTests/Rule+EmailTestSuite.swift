//
//  Rule+EmailTestSuite.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_EmailTestSuite {

    @Test
    func validEmail() async throws {
        let v = KeyValueValidator(
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
        let v = KeyValueValidator(
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
    func validInternationalEmail() async throws {
        let v = KeyValueValidator(
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
        let v = KeyValueValidator(
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

}
