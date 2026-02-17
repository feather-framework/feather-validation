//
//  Rule+CharacterSetTestSuite.swift
//  feather-validation
//
//  Created by Binary Birds on 2026. 02. 17.

import FeatherValidation
import FeatherValidationFoundation
import Testing

@Suite
struct Rule_CharacterSetTestSuite {

    @Test
    func valid() async throws {
        let ascii = String(Array(0...127).map { Character(Unicode.Scalar($0)) })
        let v = KeyValueValidator(
            key: "ch",
            value: ascii,
            rules: [
                .characterSet(.ascii)
            ]
        )
        try await v.validate()
    }

    @Test
    func invalid() async throws {
        let v = KeyValueValidator(
            key: "ch",
            value: "árvíztűrő tükörfúrógép",
            rules: [
                .characterSet(.ascii)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

    @Test
    func invalidExtendedAsciiByte() async throws {
        let extended = "abc" + String(UnicodeScalar(128)!)
        let v = KeyValueValidator(
            key: "ch",
            value: extended,
            rules: [
                .characterSet(.ascii)
            ]
        )
        do {
            try await v.validate()
            Issue.record("Validator should fail.")
        }
        catch let error {
            #expect(error.failures.count == 1)
        }
    }

}
