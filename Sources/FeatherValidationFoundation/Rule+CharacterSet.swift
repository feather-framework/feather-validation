import Foundation
import FeatherValidation

extension CharacterSet {
    
    // ASCII (byte 0..<128) character set.
    public static var ascii: CharacterSet {
        .init((0..<128).map(Unicode.Scalar.init))
    }
}

extension Rule where T == String {

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



