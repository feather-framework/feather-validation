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

    /// Builds a validator from an optional validator component.
    /// - Parameter component: An optional validator component.
    /// - Returns: The provided validator or an `EmptyValidator` when `nil`.
    public static func buildOptional(
        _ component: Validator?
    ) -> Validator {
        component ?? EmptyValidator()
    }

    /// Builds a validator from the first branch of a conditional expression.
    /// - Parameter component: The validator produced by the first branch.
    /// - Returns: The same validator.
    public static func buildEither(
        first component: Validator
    ) -> Validator {
        component
    }

    /// Builds a validator from the second branch of a conditional expression.
    /// - Parameter component: The validator produced by the second branch.
    /// - Returns: The same validator.
    public static func buildEither(
        second component: Validator
    ) -> Validator {
        component
    }
}
