//
//  Rule+StringTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct RuleStringTestSuite {

    @Test
    func nonemptyMinAndMaxRules() async throws {
        try await Rule<String>.nonempty().validate("x")
        try await Rule<String>.min(length: 2).validate("ab")
        try await Rule<String>.max(length: 3).validate("abc")

        do {
            try await Rule<String>.nonempty().validate("")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<String>.min(length: 2).validate("a")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<String>.max(length: 3).validate("abcd")
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
    func trimmedNonemptyRule() async throws {
        try await Rule<String>.trimmedNonempty().validate("  abc ")
        do {
            try await Rule<String>.trimmedNonempty().validate("  \n\t ")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func startsAndEndsRules() async throws {
        try await Rule<String>.starts(with: "pre").validate("prefix")
        try await Rule<String>.ends(with: "fix").validate("prefix")

        do {
            try await Rule<String>.starts(with: "x").validate("prefix")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<String>.ends(with: "z").validate("prefix")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

}
