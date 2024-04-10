import FeatherValidation
import FeatherValidationFoundation
import XCTest

final class Rule_EmailTests: XCTestCase {

    func testValidEmail() async throws {
        let v = KeyValueValidator(
            key: "email",
            value: "mail.tib@gmail.com",
            rules: [
                .email()
            ]
        )
        try await v.validate()
    }

    func testInvalidEmail() async throws {
        let v = KeyValueValidator(
            key: "email",
            value: "@gmail.com",
            rules: [
                .email(rule: .international)
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
