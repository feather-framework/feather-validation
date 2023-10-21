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
    ) -> [Validator] {
        components
    }
}
