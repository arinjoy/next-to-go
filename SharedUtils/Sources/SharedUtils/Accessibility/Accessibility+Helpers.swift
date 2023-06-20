//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI

public extension View {

    /// A helper to not let the font scale at too high rate after the larger accessibility font sizes
    func adaptiveScaleFactor() -> some View {
        self.modifier(AdaptiveScaleFactor())
    }

}

// MARK: - Private

private struct AdaptiveScaleFactor: ViewModifier {

    @Environment(\.sizeCategory) private var sizeCategory

    func body(content: Content) -> some View {
        if sizeCategory >= .extraExtraExtraLarge {
            content.minimumScaleFactor(0.5)
        } else {
            content.minimumScaleFactor(1)
        }
    }

}
