//
//  CollectionValidatorTestSuite.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import FeatherValidation
import Testing

@Suite
struct KeyValueValidatorTestSuite {

    @Test
    func passesWhenAllItemsAreValid() async throws {

        let validator = Validator(
            key: "items",
            value: ["a", "b", "c"],
            rules: [
                .init(message: "nonempty") {
                    let nonempty = $0.allSatisfy { !$0.isEmpty }
                    guard nonempty else {
                        throw RuleError.invalid
                    }
                }
            ]
        )

        try await validator.validate()
    }

    //    @Test
    //    func mapsIndexedChildFailures() async throws {
    //        let validator = CollectionValidator(
    //            key: "items",
    //            values: ["ok", ""]
    //        ) { _, value in
    //            AsyncValidator {
    //                KeyValueValidator(
    //                    key: "name",
    //                    value: value,
    //                    rules: [.nonempty(message: "empty")]
    //                )
    //                KeyValueValidator(
    //                    key: "bar",
    //                    value: value,
    //                    rules: [
    //                        .length(2)
    //                    ]
    //                )
    //            }
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            print(error.failures)
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "items[1].name")
    //            #expect(error.failures.first?.message == "empty")
    //        }
    //    }
    //
    //    @Test
    //    func mapsIndexedChildFailures2() async throws {
    //        let validator = KeyValueValidator(
    //            key: "items",
    //            value: ["ok", ""],
    //            rules: [
    //                .predicate(message: "empty") { $0.isEmpty }
    //            ]
    //        )
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "items")
    //            #expect(error.failures.first?.message == "empty")
    //        }
    //    }
    //
    //    @Test
    //    func requiredNilFails() async throws {
    //        let validator = CollectionValidator<[String]>(
    //            key: "items",
    //            values: nil,
    //            required: true,
    //            error: "required"
    //        ) { _, value in
    //            KeyValueValidator(
    //                key: "name",
    //                value: value,
    //                rules: [.nonempty()]
    //            )
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            #expect(error.failures.count == 1)
    //            #expect(error.failures.first?.key == "items")
    //            #expect(error.failures.first?.message == "required")
    //        }
    //    }
    //
    //    @Test
    //    func optionalNilPassesWhenNotRequired() async throws {
    //        let validator = CollectionValidator<[String]>(
    //            key: "items",
    //            values: nil,
    //            required: false
    //        ) { _, value in
    //            KeyValueValidator(
    //                key: "name",
    //                value: value,
    //                rules: [.nonempty()]
    //            )
    //        }
    //
    //        try await validator.validate()
    //    }
    //
    //    @Test
    //    func firstInvocationStopsAtFirstFailure() async throws {
    //        let validator = CollectionValidator(
    //            key: "items",
    //            values: ["", ""],
    //            invocation: .first
    //        ) { _, value in
    //            KeyValueValidator(
    //                key: "name",
    //                value: value,
    //                invocation: .all,
    //                rules: [
    //                    .nonempty(message: "empty"),
    //                    .min(length: 2, message: "min"),
    //                ]
    //            )
    //        }
    //
    //        let failures = await validator.failures()
    //        #expect(failures.count == 1)
    //        #expect(failures.first?.key == "items[0].name")
    //    }
}
