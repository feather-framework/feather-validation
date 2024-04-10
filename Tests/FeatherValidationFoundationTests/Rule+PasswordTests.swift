import FeatherValidation
import FeatherValidationFoundation
import XCTest

final class Rule_PasswordTests: XCTestCase {

    func testUppercase() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "Abcdefg",
            rules: [
                .password(rule: .uppercase)
            ]
        )
        try await v.validate()
    }

    func testUppercaseFail() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "abcdefg",
            rules: [
                .password(rule: .uppercase)
            ]
        )
        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testLowercase() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "Abcdefg",
            rules: [
                .password(rule: .lowercase)
            ]
        )
        try await v.validate()
    }

    func testLowercaseFail() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "ABCDEFG",
            rules: [
                .password(rule: .lowercase)
            ]
        )
        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testDigit() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "Abcdefg1",
            rules: [
                .password(rule: .digit)
            ]
        )
        try await v.validate()
    }

    func testDigitFail() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "ABCDEFG",
            rules: [
                .password(rule: .digit)
            ]
        )
        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCombined() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "Abcdefg1",
            rules: [
                .password(rule: .combined)
            ]
        )
        try await v.validate()
    }

    func testCombinedfail() async throws {
        let v = KeyValueValidator(
            key: "password",
            value: "Aaavkjn.-",
            rules: [
                .password(rule: .combined)
            ]
        )
        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
        }
        catch {
            XCTFail("\(error)")
        }
    }

}
