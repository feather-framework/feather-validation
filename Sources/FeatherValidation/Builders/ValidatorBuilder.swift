/// DSL syntax for Validator objects
@resultBuilder
public enum ValidatorBuilder {

    ///
    /// Builds a Validator array from the given components
    ///
    /// - Parameters:
    ///   - components: The validator components
    /// - Returns: The Validator array
    public static func buildBlock(
        _ components: Validator...
    ) -> Validator {
        AsyncValidator(components)
    }

    public static func buildOptional(
        _ component: Validator?
    ) -> Validator {
        component ?? EmptyValidator()
    }

    public static func buildEither(
        first component: Validator
    ) -> Validator {
        component
    }

    public static func buildEither(
        second component: Validator
    ) -> Validator {
        component
    }
}
