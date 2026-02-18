//
//  Rule+ContainsTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct RuleContainsTestSuite {

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
    func containsAndNotEqualsRules() async throws {
        try await Rule<String>.notContains(options: ["x", "y"]).validate("a")
        try await Rule<String>.notEquals("x").validate("a")

        do {
            try await Rule<String>.notContains(options: ["x", "y"]).validate("x")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<String>.notEquals("x").validate("x")
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
