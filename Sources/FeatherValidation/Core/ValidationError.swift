//
//  ValidationError.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2024. 05. 27.

/// Validator error object
public struct ValidationError: Error {

    /// Initializes a new `ValidationError` with a list of failures.
    /// - Parameter failures: An array of `Failure` objects.
    public init(failures: [Failure]) {
        self.failures = failures
    }

    /// List of failure objects
    public let failures: [Failure]
}
