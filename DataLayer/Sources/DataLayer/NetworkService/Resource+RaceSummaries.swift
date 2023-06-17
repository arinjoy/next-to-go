//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation

extension Resource {
    
    ///
    /// Fetches the next x number of races for a given category
    /// If no category is provided (i.e. nil), means a mix of all types of
    /// races will be returned up to the given preference
    /// - Parameters:
    ///   - categoryId: The stringi-fied category id for a race type.
    ///   - count: The number of race results to fetch
    /// - Returns: The list of races
    ///
    public static func nextRaces(
        forCategory categoryId: String? = nil, // Defaults to all kind of races
        numberOfRaces count: Int = 5           // Defaults to 5 races
    ) -> Resource<RacesListResponse> {
        
        let baseURL = ApiConstants.baseURL
        var parameters: [String : CustomStringConvertible] = [
            "method": "nextraces",
            "count": count
        ]
        
        if let categoryId {
            parameters["category_id"] = categoryId
        }
        return Resource<RacesListResponse>(url: baseURL, parameters: parameters)
    }
    
}
