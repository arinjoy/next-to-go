//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import Foundation

///
/// Helps joining multiple string components to create a combined accessibility label string
/// with comma separators. Accepts `nil` s for convenience but ignores them. Also trims
/// anything needed and creates the final result that is a legible sound for VoiceOver.
///
/// Example: Input: `["Hello", "", " World", " ", nil, "test"]`
///        Output: `"Hello, World, test"`
///
public extension Array where Element == String? {

    func combinedAccessibilityLabel() -> String {
        self.compactMap { $0?.trimmed() }
            .filter { $0.isEmpty == false }
            .joined(separator: ", ")
    }

}

public extension String {

    var isEmpty: Bool {
        self.trimmed().lengthOfBytes(using: String.Encoding.utf8) == 0
    }

    var isNotEmpty: Bool {
        self.isEmpty == false
    }

    func trimmed() -> String {
        self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

}

public extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }

    var isNotEmpty: Bool {
        isEmptyOrNil == false
    }

}

