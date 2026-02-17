//
//  Validator.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

/// The validator protocol
public protocol Validator: Sendable {

    /// Performs validation and throws on failure.
    func validate() async throws(ValidatorError)
}

public extension Validator {

    /// Returns all failures produced by this validator.
    /// - Returns: An empty array if validation succeeds, otherwise the collected failures.
    func failures() async -> [Failure] {
        do {
            try await validate()
            return []
        }
        catch let error {
            return error.failures
        }
    }

    /// Indicates whether validation succeeds.
    /// - Returns: `true` when no failures are produced.
    func isValid() async -> Bool {
        await failures().isEmpty
    }
}
