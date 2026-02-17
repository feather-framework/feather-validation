//
//  Rule+CharacterSet.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

import Foundation
import FeatherValidation

extension CharacterSet {

    /// ASCII (`0..<128`) character set.
    public static var ascii: CharacterSet {
        .init((0..<128).map(Unicode.Scalar.init))
    }
}

extension Rule where T == String {

    /// Validates that all characters in the string are contained in `characterSet`.
    /// - Parameters:
    ///   - characterSet: The allowed character set.
    ///   - message: Optional custom failure message.
    /// - Returns: A string validation rule.
    public static func characterSet(
        _ characterSet: CharacterSet,
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value contains invalid character(s)."
        ) { value in
            guard
                value.rangeOfCharacter(from: characterSet.inverted) == nil
            else {
                throw RuleError.invalid
            }
        }
    }
}
