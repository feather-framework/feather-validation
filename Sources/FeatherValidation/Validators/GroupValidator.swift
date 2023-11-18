// Groups a collection of validators using a ValidatorBuilder
public struct GroupValidator: Validator {

    let validator: Validator

    public init(
        @ValidatorBuilder _ validator: () -> Validator
    ) {
        self.validator = validator()
    }

    public func validate() async throws {
        try await validator.validate()
    }
}
