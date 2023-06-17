//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation


extension Resource {
    
    public static func nextFiveRaces() -> Resource<RacesListResponse> {
        let baseURL = ApiConstants.baseURL
        let parameters: [String : CustomStringConvertible] = [
            "method": "nextraces",
            "count": "5"
        ]
        return Resource<RacesListResponse>(url: baseURL, parameters: parameters)
    }
    
}
