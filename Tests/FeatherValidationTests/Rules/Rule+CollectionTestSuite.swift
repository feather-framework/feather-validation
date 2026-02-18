//
//  Rule+CollectionTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct RuleCollectionTestSuite {

    @Test
    func collectionCountRules() async throws {
        let values = [1, 2, 3]
        try await Rule<[Int]>.count(min: 2).validate(values)
        try await Rule<[Int]>.count(max: 3).validate(values)
        try await Rule<[Int]>.count(3).validate(values)

        do {
            try await Rule<[Int]>.count(min: 4).validate(values)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<[Int]>.count(max: 2).validate(values)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            try await Rule<[Int]>.count(2).validate(values)
            Issue.record("Rule should fail.")
        }
        catch RuleError.invalid {}
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
