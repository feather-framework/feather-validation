import Foundation
import FeatherValidation

extension Rule where T == String {

    public enum PasswordValidationRule {
        case uppercase
        case lowercase
        case digit
        case combined
    }

    public static func password(
        rule: PasswordValidationRule = .digit,
        message: String? = nil
    ) -> Self {

        .init(
            message: message ?? "The value is an invalid password."
        ) { value in
            switch rule {
            case .uppercase:
                let regex: String = "(?=.*[A-Z])"
                guard
                    let _ = value.range(
                        of: regex,
                        options: [.regularExpression]
                    )
                else {
                    throw RuleError.invalid
                }
            case .lowercase:
                let regex: String = "(?=.*[a-z])"
                guard
                    let _ = value.range(
                        of: regex,
                        options: [.regularExpression]
                    )
                else {
                    throw RuleError.invalid
                }
            case .digit:
                let regex: String = "(?=.*\\d)"
                guard
                    let _ = value.range(
                        of: regex,
                        options: [.regularExpression]
                    )
                else {
                    throw RuleError.invalid
                }
            case .combined:
                let regex: String = #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#
                guard
                    let _ = value.range(
                        of: regex,
                        options: [.regularExpression]
                    )
                else {
                    throw RuleError.invalid
                }
            }
        }

    }

}
