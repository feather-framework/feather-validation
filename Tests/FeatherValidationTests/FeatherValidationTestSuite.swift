//
//  FeatherValidationTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct FeatherValidationTestSuite {

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
    func optionalExample() async throws {
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
}
