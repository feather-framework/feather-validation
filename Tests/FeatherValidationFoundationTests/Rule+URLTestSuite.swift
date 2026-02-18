//
//  Rule+URLTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_URLTestSuite {

    @Test
    func validURL() async throws {
        let v = Validator(
            key: "url",
            value: "http://swift.org/",
            rules: [
                .url(message: "url")
            ]
        )
        try await v.validate()
    }

    @Test
    func validFileURL() async throws {
        let v = Validator(
            key: "url",
            value: "file:///Users/tib/",
            rules: [
                .url(message: "url")
            ]
        )
        try await v.validate()
    }

    @Test
    func customProtocol() async throws {
        let v = Validator(
            key: "url",
            value: "feather-cms://swift.org",
            rules: [
                .url(message: "url")
            ]
        )
        try await v.validate()
    }

    @Test
    func invalidURL() async throws {
        let v = Validator(
            key: "url",
            value: "invalid",
            rules: [
                .url(message: "url")
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
    func invalidURLUsesDefaultMessage() async throws {
        let v = Validator(
            key: "url",
            value: "invalid",
            rules: [
                .url()
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "The value is an invalid URL.")
        }
    }

    @Test
    func missingHostFails() async throws {
        let v = Validator(
            key: "url",
            value: "http://",
            rules: [
                .url(message: "url")
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
    func missingSchemeFails() async throws {
        let v = Validator(
            key: "url",
            value: "swift.org",
            rules: [
                .url(message: "url")
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
    func customMessageOnURLFailure() async throws {
        let v = Validator(
            key: "url",
            value: "invalid",
            rules: [
                .url(message: "bad url")
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.message == "bad url")
        }
    }
}
