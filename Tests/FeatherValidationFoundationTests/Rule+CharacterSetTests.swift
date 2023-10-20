import FeatherValidation
import FeatherValidationFoundation
import XCTest

final class Rule_CharacterSetTests: XCTestCase {

    func testValid() async throws {
        let ascii = String(Array(0...127).map { Character(Unicode.Scalar($0)) })
        let v = KeyValueValidator(
            key: "ch",
            value: ascii,
            rules: [
                .characterSet(.ascii)
            ]
        )
        try await v.validate()
    }

    func testInvalid() async throws {
        let v = KeyValueValidator(
            key: "ch",
            value: "árvíztűrő tükörfúrógép",
            rules: [
                .characterSet(.ascii)
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
