import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_URLTestSuite {

    @Test
    func validURL() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "http://swift.org/",
            rules: [
                .url(message: "url")
            ]
        )
        try await v.validate()
    }

    @Test
    func validFileURL() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "file:///Users/tib/",
            rules: [
                .url(message: "url")
            ]
        )
        try await v.validate()
    }

    @Test
    func customProtocol() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "feather-cms://swift.org",
            rules: [
                .url(message: "url")
            ]
        )
        try await v.validate()
    }

    @Test
    func invalidURL() async throws {
        let v = KeyValueValidator(
            key: "url",
            value: "invalid",
            rules: [
                .url(message: "url")
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
