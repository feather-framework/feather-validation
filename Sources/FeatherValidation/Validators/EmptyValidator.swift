//
//  EmptyValidator.swift
//  feather-validation
//
//  Created by Tibor Bödecs on 2023. 11. 02.

struct EmptyValidator: Validator {
    func validate() async throws(ValidatorError) {}
}
