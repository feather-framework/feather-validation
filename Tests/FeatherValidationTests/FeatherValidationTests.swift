import FeatherValidation
import XCTest

final class FeatherValidationTests: XCTestCase {

    func testBasicExample() async throws {
        let key = "foo"
        let value = ""

        let v = GroupValidator {
            KeyValueValidator(
                key: key,
                value: value,
                invocation: .all,
                rules: [
                    .nonempty(message: "empty"),
                    .min(length: 2, message: "min"),
                    .max(length: 32),
                    .init(
                        message: "ouch",
                        { _ in
                            throw RuleError.invalid
                        }
                    ),
                ]
            )
        }

        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 3)
            for failure in error.failures {
                XCTAssertEqual(failure.key, key)
            }
            let messages = error.failures.map { $0.message }
            XCTAssertTrue(messages.contains("empty"))
            XCTAssertTrue(messages.contains("min"))
            XCTAssertTrue(messages.contains("ouch"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testNilExample() async throws {
        let key = "foo"
        let value: String? = nil

        let v = GroupValidator {
            KeyValueValidator(
                key: key,
                value: value,
                required: true,
                error: "req",
                invocation: .all,
                rules: [
                    .min(length: 2, message: "min")
                ]
            )
        }

        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)

            let messages = error.failures.map { $0.message }
            XCTAssertTrue(messages.contains("req"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testOptionalExample() async throws {
        let key = "foo"
        let value: String? = ""

        let v = GroupValidator {
            KeyValueValidator(
                key: key,
                value: value,
                invocation: .all,
                rules: [
                    .nonempty(message: "empty"),
                    .min(length: 2, message: "min"),
                    .max(length: 32),
                    .init(
                        message: "ouch",
                        { _ in
                            throw RuleError.invalid
                        }
                    ),
                ]
            )
        }

        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 3)
            for failure in error.failures {
                XCTAssertEqual(failure.key, key)
            }
            let messages = error.failures.map { $0.message }
            XCTAssertTrue(messages.contains("empty"))
            XCTAssertTrue(messages.contains("min"))
            XCTAssertTrue(messages.contains("ouch"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testNil2Example() async throws {
        let key = "foo"
        let value: String? = nil

        let v = GroupValidator {
            if let value = value {
                KeyValueValidator(
                    key: key,
                    value: value,
                    required: true,
                    error: "req",
                    invocation: .all,
                    rules: [
                        .min(length: 2, message: "min")
                    ]
                )
            }
            else {
                Failure(key: "title", message: "req")
            }
        }

        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)

            let messages = error.failures.map { $0.message }
            XCTAssertTrue(messages.contains("req"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
}
