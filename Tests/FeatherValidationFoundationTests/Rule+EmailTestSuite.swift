import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_EmailTestSuite {

    @Test
    func validEmail() async throws {
        let v = KeyValueValidator(
            key: "email",
            value: "mail.tib@gmail.com",
            rules: [
                .email()
            ]
        )
        try await v.validate()
    }

    @Test
    func invalidEmail() async throws {
        let v = KeyValueValidator(
            key: "email",
            value: "@gmail.com",
            rules: [
                .email(rule: .international)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error as ValidatorError {
            #expect(error.failures.count == 1)
        }
        catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

}
