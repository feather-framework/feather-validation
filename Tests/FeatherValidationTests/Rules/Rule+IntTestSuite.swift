//
//  Rule+IntTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct RuleIntTestSuite {

    @Test
    func intMinRule() async throws {
        try await Rule<Int>.min(10).validate(10)
        do {
            try await Rule<Int>.min(10).validate(9)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func intMaxRule() async throws {
        try await Rule<Int>.max(10).validate(10)
        do {
            try await Rule<Int>.max(10).validate(11)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func intEqualsRule() async throws {
        try await Rule<Int>.equals(42).validate(42)
        do {
            try await Rule<Int>.equals(42).validate(41)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func intRangeAndSignRules() async throws {
        try await Rule<Int>.range(1...3).validate(2)
        try await Rule<Int>.positive().validate(1)
        try await Rule<Int>.nonNegative().validate(0)
        try await Rule<Int>.negative().validate(-1)

        do {
            try await Rule<Int>.range(1...3).validate(4)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<Int>.positive().validate(0)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<Int>.nonNegative().validate(-1)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<Int>.negative().validate(0)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

}
