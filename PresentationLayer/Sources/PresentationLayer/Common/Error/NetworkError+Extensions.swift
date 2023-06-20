//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import Foundation
import SharedUtils
import DataLayer

extension NetworkError {

    // TODO: Map more custom error messages
    /// such `serviceUnavailable`, `forbidden` etc.
    /// based on the use cases and granularity of messaging required.
    ///
    var title: String {
        switch self {
        case .networkFailure:
            return "next.togo.races.error.network.heading".l10n()
        default:
            return "next.togo.races.error.generic.heading".l10n()
        }
    }

    var message: String {
        switch self {
        case .networkFailure:
            return "next.togo.races.error.network.message".l10n()
        default:
            return "next.togo.races.error.generic.message".l10n()
        }
    }
    
    var iconName: String {
        switch self {
        case .networkFailure:
            return "wifi.exclamationmark"
        default:
            return "exclamationmark.icloud"
        }
    }
    
}
