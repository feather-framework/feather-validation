import FeatherValidation
import Testing

@Suite
struct RuleExtensionsTestSuite {

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
