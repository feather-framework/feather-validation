//
//  Rule+Password.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

import Foundation
import FeatherValidation

extension Rule where T == String {

    /// Password validation profiles.
    public enum PasswordValidationRule: Sendable {
        /// Requires at least one uppercase character.
        case uppercase
        /// Requires at least one lowercase character.
        case lowercase
        /// Requires at least one digit.
        case digit
        /// Requires uppercase, lowercase, and digit characters.
        case combined
    }

    /// Validates passwords using the selected validation profile.
    /// - Parameters:
    ///   - rule: The password validation profile to apply.
    ///   - message: Optional custom failure message.
    /// - Returns: A string validation rule.
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
                let regex: String =
                    #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#
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
