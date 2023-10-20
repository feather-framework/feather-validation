@resultBuilder
public enum ValidatorBuilder {

    public static func buildBlock(
        _ components: Validator...
    ) -> [Validator] {
        components
    }
}
