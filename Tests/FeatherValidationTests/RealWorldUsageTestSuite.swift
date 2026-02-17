//
//  RealWorldUsageTestSuite.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

import FeatherValidation
import FeatherValidationFoundation
import Testing

// TODO: move this out to the example repository. no need for this here.

private struct RegistrationInput: Sendable {
    let email: String?
    let password: String?
    let confirmPassword: String?
    let age: Int?
}

private struct CheckoutItem: Sendable {
    let sku: String?
    let quantity: Int?
}

private struct CheckoutInput: Sendable {
    let items: [CheckoutItem]?
    let minTotal: Int?
    let maxTotal: Int?
}

private struct BookingInput: Sendable {
    let title: String?
    let startsAt: Int?
    let endsAt: Int?
}

private struct ProfileUpdateInput: Sendable {
    let username: String?
    let website: String?
    let tags: [String]?
}

@Suite
struct RealWorldUsageTestSuite {

    /// A realistic registration form with field-level and cross-field constraints.
    //    @Test
    //    func registrationFlowCollectsFieldAndDependentFailures() async throws {
    //        let input = RegistrationInput(
    //            email: "bad",
    //            password: "short",
    //            confirmPassword: "mismatch",
    //            age: 14
    //        )
    //
    //        let validator = AsyncValidator {
    //            KeyValueValidator(
    //                key: "email",
    //                value: input.email,
    //                invocation: .all,
    //                rules: [
    //                    .nonempty(message: "Email is required."),
    //                    .email(message: "Email is invalid."),
    //                ]
    //            )
    //
    //            KeyValueValidator(
    //                key: "password",
    //                value: input.password,
    //                invocation: .all,
    //                rules: [
    //                    .min(length: 8, message: "Password is too short."),
    //                    .password(
    //                        rule: .combined,
    //                        message:
    //                            "Password must contain uppercase, lowercase and digit."
    //                    ),
    //                ]
    //            )
    //
    //            KeyValueValidator(
    //                key: "age",
    //                value: input.age,
    //                rules: [
    //                    .min(18, message: "You must be at least 18 years old.")
    //                ]
    //            )
    //
    //            KeyValueValidator(
    //                key: "password",
    //                value: (input.password, input.confirmPassword),
    //                rules: [
    //                    .init(message: "foo") { (left, right) in
    //                        if left != right {
    //                            throw RuleError.invalid
    //                        }
    //                    }
    //                ]
    //            )

    //            DependentFieldsValidator(
    //                leftKey: "password",
    //                leftValue: input.password,
    //                rightKey: "confirmPassword",
    //                rightValue: input.confirmPassword,
    //                failureKey: "confirmPassword",
    //                message: "Passwords do not match."
    //            ) { left, right in
    //                if left != right {
    //                    throw RuleError.invalid
    //                }
    //            }
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            let keys = Set(error.failures.map(\.key))
    //            #expect(keys.contains("email"))
    //            #expect(keys.contains("password"))
    //            #expect(keys.contains("age"))
    //            #expect(keys.contains("confirmPassword"))
    //
    //            let messages = Set(error.failures.map(\.message))
    //            #expect(messages.contains("Email is invalid."))
    //            #expect(messages.contains("Password is too short."))
    //            #expect(messages.contains("You must be at least 18 years old."))
    //            #expect(messages.contains("Passwords do not match."))
    //        }
    //    }

    /// A checkout payload that validates dynamic line items plus order-level totals.
    //    @Test
    //    func checkoutFlowMapsIndexedItemFailuresAndCrossFieldFailure() async throws
    //    {
    //        let input = CheckoutInput(
    //            items: [
    //                .init(sku: "ABC-123", quantity: 1),
    //                .init(sku: "", quantity: 0),
    //            ],
    //            minTotal: 200,
    //            maxTotal: 100
    //        )
    //
    //        let validator = AsyncValidator {
    //            CollectionValidator(
    //                key: "items",
    //                values: input.items,
    //                required: true,
    //                error: "At least one item is required.",
    //                invocation: .all
    //            ) { _, item in
    //                AsyncValidator {
    //                    KeyValueValidator(
    //                        key: "sku",
    //                        value: item.sku,
    //                        rules: [
    //                            .trimmedNonempty(message: "SKU is required.")
    //                        ]
    //                    )
    //                    KeyValueValidator(
    //                        key: "quantity",
    //                        value: item.quantity,
    //                        rules: [
    //                            .positive(message: "Quantity must be positive.")
    //                        ]
    //                    )
    //                }
    //            }
    //
    //            DependentFieldsValidator(
    //                leftKey: "minTotal",
    //                leftValue: input.minTotal,
    //                rightKey: "maxTotal",
    //                rightValue: input.maxTotal,
    //                message: "minTotal must be less than or equal to maxTotal."
    //            ) { left, right in
    //                if let left, let right, left > right {
    //                    throw RuleError.invalid
    //                }
    //            }
    //        }
    //
    //        do {
    //            try await validator.validate()
    //            Issue.record("Validator should fail.")
    //        }
    //        catch let error {
    //            let keyedMessages = Dictionary(
    //                uniqueKeysWithValues: error.failures.map {
    //                    ($0.key, $0.message)
    //                }
    //            )
    //            #expect(keyedMessages["items[1].sku"] == "SKU is required.")
    //            let quantityMessage = "Quantity must be positive."
    //            #expect(
    //                keyedMessages["items[1].quantity"] == quantityMessage
    //            )
    //            #expect(
    //                keyedMessages["minTotal,maxTotal"]
    //                    == "minTotal must be less than or equal to maxTotal."
    //            )
    //        }
    //    }

    //    /// Happy path registration example.
    //    @Test
    //    func registrationFlowPassesForValidInput() async throws {
    //        let input = RegistrationInput(
    //            email: "user@example.com",
    //            password: "StrongPass1",
    //            confirmPassword: "StrongPass1",
    //            age: 20
    //        )
    //
    //        let validator = AsyncValidator {
    //            KeyValueValidator(
    //                key: "email",
    //                value: input.email,
    //                rules: [
    //                    .email()
    //                ]
    //            )
    //            KeyValueValidator(
    //                key: "password",
    //                value: input.password,
    //                rules: [
    //                    .password(rule: .combined)
    //                ]
    //            )
    //            KeyValueValidator(
    //                key: "age",
    //                value: input.age,
    //                rules: [
    //                    .min(18)
    //                ]
    //            )
    //            DependentFieldsValidator(
    //                leftKey: "password",
    //                leftValue: input.password,
    //                rightKey: "confirmPassword",
    //                rightValue: input.confirmPassword
    //            ) { left, right in
    //                if left != right {
    //                    throw RuleError.invalid
    //                }
    //            }
    //        }
    //
    //        try await validator.validate()
    //    }
    //
    //    /// Booking form validation where start and end values must be consistent.
    //    @Test
    //    func bookingFlowValidatesDateOrderAndTitle() async throws {
    //        let input = BookingInput(
    //            title: "  ",
    //            startsAt: 2000,
    //            endsAt: 1000
    //        )
    //
    //        let validator = AsyncValidator {
    //            KeyValueValidator(
    //                key: "title",
    //                value: input.title,
    //                rules: [
    //                    .trimmedNonempty(message: "Title is required.")
    //                ]
    //            )
    //            DependentFieldsValidator(
    //                leftKey: "startsAt",
    //                leftValue: input.startsAt,
    //                rightKey: "endsAt",
    //                rightValue: input.endsAt,
    //                message: "startsAt must be less than or equal to endsAt."
    //            ) { left, right in
    //                if let left, let right, left > right {
    //                    throw RuleError.invalid
    //                }
    //            }
    //        }
    //
    //        let failures = await validator.failures()
    //        #expect(failures.count == 2)
    //        let keyedMessages = Dictionary(
    //            uniqueKeysWithValues: failures.map { ($0.key, $0.message) }
    //        )
    //        #expect(keyedMessages["title"] == "Title is required.")
    //        #expect(
    //            keyedMessages["startsAt,endsAt"]
    //                == "startsAt must be less than or equal to endsAt."
    //        )
    //    }
    //
    //    /// Profile update validation that combines simple fields and a tag list.
    //    @Test
    //    func profileUpdateFlowValidatesUsernameWebsiteAndTags() async throws {
    //        let input = ProfileUpdateInput(
    //            username: "xy",
    //            website: "invalid-url",
    //            tags: ["swift", "", "backend"]
    //        )
    //
    //        let validator = AsyncValidator {
    //            KeyValueValidator(
    //                key: "username",
    //                value: input.username,
    //                invocation: .all,
    //                rules: [
    //                    .trimmedNonempty(message: "Username is required."),
    //                    .min(length: 3, message: "Username is too short."),
    //                    .max(length: 20, message: "Username is too long."),
    //                ]
    //            )
    //            KeyValueValidator(
    //                key: "website",
    //                value: input.website,
    //                required: false,
    //                rules: [
    //                    .url(message: "Website URL is invalid.")
    //                ]
    //            )
    //            CollectionValidator(
    //                key: "tags",
    //                values: input.tags,
    //                required: false
    //            ) { _, tag in
    //                KeyValueValidator(
    //                    key: "value",
    //                    value: tag,
    //                    rules: [
    //                        .trimmedNonempty(message: "Tag is required.")
    //                    ]
    //                )
    //            }
    //        }
    //
    //        let failures = await validator.failures()
    //        #expect(failures.count == 3)
    //        let keyedMessages = Dictionary(
    //            uniqueKeysWithValues: failures.map { ($0.key, $0.message) }
    //        )
    //        #expect(keyedMessages["username"] == "Username is too short.")
    //        #expect(keyedMessages["website"] == "Website URL is invalid.")
    //        #expect(keyedMessages["tags[1].value"] == "Tag is required.")
    //    }
    //
    //    /// Happy path profile update example.
    //    @Test
    //    func profileUpdateFlowPassesForValidPayload() async throws {
    //        let input = ProfileUpdateInput(
    //            username: "swiftdev",
    //            website: "https://example.com",
    //            tags: ["swift", "backend"]
    //        )
    //
    //        let validator = AsyncValidator {
    //            KeyValueValidator(
    //                key: "username",
    //                value: input.username,
    //                rules: [
    //                    .trimmedNonempty(),
    //                    .min(length: 3),
    //                    .max(length: 20),
    //                ]
    //            )
    //            KeyValueValidator(
    //                key: "website",
    //                value: input.website,
    //                required: false,
    //                rules: [.url()]
    //            )
    //            CollectionValidator(
    //                key: "tags",
    //                values: input.tags,
    //                required: false
    //            ) { _, tag in
    //                KeyValueValidator(
    //                    key: "value",
    //                    value: tag,
    //                    rules: [.trimmedNonempty()]
    //                )
    //            }
    //        }
    //
    //        try await validator.validate()
    //    }
}
