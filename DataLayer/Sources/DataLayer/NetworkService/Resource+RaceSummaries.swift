//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation


extension Resource {
    
    public static func nextFiveRaces(forCategory categoryId: String? = nil) -> Resource<RacesListResponse> {
        let baseURL = ApiConstants.baseURL
        var parameters: [String : CustomStringConvertible] = [
            "method": "nextraces",
            "count": "5"
        ]
        if let categoryId {
            parameters["category_id"] = categoryId
        }
        return Resource<RacesListResponse>(url: baseURL, parameters: parameters)
    }
    
}
