import Foundation
import FeatherValidation

extension Rule where T == String {

    public static func url(
        message: String? = nil
    ) -> Self {
        .init(
            message: message ?? "The value is an invalid URL."
        ) { value in
            guard
                let url = URL(string: value), url.isFileURL || (url.host != nil && url.scheme != nil)
            else {
                throw RuleError.invalid
            }
        }
    }
}



