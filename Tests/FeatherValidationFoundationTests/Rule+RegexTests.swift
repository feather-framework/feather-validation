import FeatherValidation
import FeatherValidationFoundation
import XCTest

final class Rule_RegexTests: XCTestCase {

    func testValidEmail() async throws {
        let v = KeyValueValidator(
            key: "email",
            value: "mail.tib@gmail.com",
            rules: [
                .email(),
            ]
        )
        try await v.validate()
    }
    
    func testInvalidEmail() async throws {
        let v = KeyValueValidator(
            key: "email",
            value: "@gmail.com",
            rules: [
                .email(rule: .international),
            ]
        )
        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch ValidatorError.result(let failures) {
            XCTAssertEqual(failures.count, 1)
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
   
}

