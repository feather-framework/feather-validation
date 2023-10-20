import FeatherValidation
import XCTest

final class FeatherValidationTests: XCTestCase {
    
    func testBasicExample() async throws {
        let key = "foo"
        let value = ""

        let v = GroupValidator(strategy: .parallel) {
            KeyValueValidator(
                key: key,
                value: value,
                invocation: .all,
                rules: [
                    .required(message: "req"),
                    .min(length: 2, message: "min"),
                    .max(length: 32),
                    .init(message: "ouch", { _ in
                        throw RuleError.invalid
                    }),
                ]
            )
        }

        do {
            try await v.validate()
            XCTFail("Validator should fail.")
        }
        catch ValidatorError.result(let failures) {
            XCTAssertEqual(failures.count, 3)
            for failure in failures {
                XCTAssertEqual(failure.key, key)
            }
            let messages = failures.map { $0.message }
            XCTAssertTrue(messages.contains("req"))
            XCTAssertTrue(messages.contains("min"))
            XCTAssertTrue(messages.contains("ouch"))
        }
        catch {
            XCTFail("\(error)")
        }
    }
}
