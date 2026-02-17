import FeatherValidation
import Testing

@Suite
struct CollectionValidatorTestSuite {

    @Test
    func passesWhenAllItemsAreValid() async throws {
        let validator = CollectionValidator(
            key: "items",
            values: ["a", "b", "c"]
        ) { _, value in
            KeyValueValidator(
                key: "name",
                value: value,
                rules: [.nonempty()]
            )
        }

        try await validator.validate()
    }

    @Test
    func mapsIndexedChildFailures() async throws {
        let validator = CollectionValidator(
            key: "items",
            values: ["ok", ""]
        ) { _, value in
            KeyValueValidator(
                key: "name",
                value: value,
                rules: [.nonempty(message: "empty")]
            )
        }

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.key == "items[1].name")
            #expect(error.failures.first?.message == "empty")
        }
    }

    @Test
    func requiredNilFails() async throws {
        let validator = CollectionValidator<[String]>(
            key: "items",
            values: nil,
            required: true,
            error: "required"
        ) { _, value in
            KeyValueValidator(
                key: "name",
                value: value,
                rules: [.nonempty()]
            )
        }

        do {
            try await validator.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
            #expect(error.failures.first?.key == "items")
            #expect(error.failures.first?.message == "required")
        }
    }

    @Test
    func optionalNilPassesWhenNotRequired() async throws {
        let validator = CollectionValidator<[String]>(
            key: "items",
            values: nil,
            required: false
        ) { _, value in
            KeyValueValidator(
                key: "name",
                value: value,
                rules: [.nonempty()]
            )
        }

        try await validator.validate()
    }

    @Test
    func firstInvocationStopsAtFirstFailure() async throws {
        let validator = CollectionValidator(
            key: "items",
            values: ["", ""],
            invocation: .first
        ) { _, value in
            KeyValueValidator(
                key: "name",
                value: value,
                invocation: .all,
                rules: [
                    .nonempty(message: "empty"),
                    .min(length: 2, message: "min"),
                ]
            )
        }

        let failures = await validator.failures()
        #expect(failures.count == 1)
        #expect(failures.first?.key == "items[0].name")
    }
}
