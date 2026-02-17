//
//  Failure.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2026. 02. 17.

/// A single validation failure entry.
public struct Failure {

    /// The field key associated with the failure.
    public let key: String

    /// The human-readable failure message.
    public let message: String
}

extension Failure: Validation {

    /// Throws a `ValidatorError` containing this single failure.
    public func validate() async throws(ValidationError) {
        throw ValidationError(failures: [self])
    }
}
