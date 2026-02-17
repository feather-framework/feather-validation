//
//  Rule+URL.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

import Foundation
import FeatherValidation

extension Rule where T == String {

    /// Validates URL strings (file URLs or URLs with both scheme and host).
    /// - Parameter message: Optional custom failure message.
    /// - Returns: A string validation rule.
    public static func url(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is an invalid URL."
        ) { value in
            guard
                let url = URL(string: value),
                url.isFileURL || (url.host != nil && url.scheme != nil)
            else {
                throw RuleError.invalid
            }
        }
    }
}
