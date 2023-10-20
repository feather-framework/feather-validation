import FeatherValidation
import FeatherValidationFoundation
import XCTest

final class Rule_URLTests: XCTestCase {

    func testValidURL() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "http://swift.org/",
            rules: [
                .url(message: "url"),
            ]
        )
        try await v.validate()
    }
    
    func testValidFileURL() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "file:///Users/tib/",
            rules: [
                .url(message: "url"),
            ]
        )
        try await v.validate()
    }
    
    func tesCustomProtocol() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "feather-cms://swift.org",
            rules: [
                .url(message: "url"),
            ]
        )
        try await v.validate()
    }
    
    func testInvalidURL() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "invalid",
            rules: [
                .url(message: "url"),
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
