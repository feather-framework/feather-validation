//
//  Rule+ComparableTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct RuleComparableTestSuite {

    @Test
    func comparableRules() async throws {
        try await Rule<Int>.lessThan(10).validate(9)
        try await Rule<Int>.lessThanOrEqual(10).validate(10)
        try await Rule<Int>.greaterThan(10).validate(11)
        try await Rule<Int>.greaterThanOrEqual(10).validate(10)
        try await Rule<Int>.between(1...3).validate(2)

        do {
            try await Rule<Int>.lessThan(10).validate(10)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<Int>.between(1...3).validate(4)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func comparableBoundaryFailures() async throws {
        do {
            try await Rule<Int>.lessThanOrEqual(10).validate(11)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<Int>.greaterThan(10).validate(10)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<Int>.greaterThanOrEqual(10).validate(9)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
