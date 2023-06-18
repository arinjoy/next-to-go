//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation

public struct Resource<T: Decodable> {
    
    // MARK: - Properties
    
    let url: URL
    let parameters: [String: CustomStringConvertible]
    
    // MARK: - Initializer
    
    public init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
    
    // MARK: - Helper
    
    var request: URLRequest? {
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        
        components.queryItems = parameters.keys
            .sorted { $0 > $1 }
            .map { key in
                URLQueryItem(name: key, value: parameters[key]?.description)
            }
        
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

}

