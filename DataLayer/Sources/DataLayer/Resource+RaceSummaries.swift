//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation

extension Resource {
    
    ///
    /// Fetches the next x number of races combining all categories.
    ///
    /// ‼️ The API is designed to not have category based filtering in query
    /// parameter and we can always get the combination effect from  each categories. ‼️
    ///
    /// Races will be returned up to the given preference count in total.
    /// - Parameters:
    ///   - count: The number of races to fetch.
    /// - Returns: The list of races.
    ///
    public static func nextRaces(numberOfRaces count: Int) -> Resource<RacesListResponse> {
        
        let baseURL = ApiConstants.baseURL
        
        let parameters: [String : CustomStringConvertible] = [
            "method": "nextraces",
            "count": count
        ]
        
        return Resource<RacesListResponse>(url: baseURL, parameters: parameters)
    }
    
}
