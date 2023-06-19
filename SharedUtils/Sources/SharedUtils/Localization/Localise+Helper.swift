//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import Foundation

public extension String {
    
    func l10n(bundle: Bundle = .main) -> String {
        NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
    
}

