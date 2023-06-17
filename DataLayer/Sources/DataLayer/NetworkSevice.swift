//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import SharedUtils

final class NetworkService: NetworkServiceType {

    private let session: URLSession

    init(with configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {
        
        guard let request = resource.request else {
            return .fail(NetworkError.unknown)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                // 1. Check for network connection related error first
                return self.mapConnectivityError(error)
            }
            .tryMap { data, response  in

                // 2. If reponse came back, check if data exists via `HTTPURLResponse`
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.noDataFound
                }

                // 3. If data exists, then check for negative/faliure HTTP status code
                // and map them to custom errors for potential custom handling
                guard 200..<300 ~= response.statusCode else {
                    throw self.mapHTTPStatusError(statusCode: response.statusCode)
                }
                
                // 4. If everyhting went well return the data response to be
                // decoded as JSON as next step
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map {
                // 5. JSON decoding is successful and return decoded entity/model
                return $0
            }
            .catch { error -> AnyPublisher<T, NetworkError> in
                
                // 6. If JSON decoding fails, from decode above (i.e. error came as non NetworkError)
                // return decoding error
                guard let networkError = error as? NetworkError else {
                    return .fail(NetworkError.jsonDecodingError(error: error))
                }
                
                // 7. Else, just pass the already mapped NetworkError
                return .fail(networkError)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Custom Error Mapping Helpers
    
    /// Maps an Error from potential NSError from network connectivity issues
    private func mapConnectivityError(_ error: Error) -> NetworkError {
        let networkError: NSError = error as NSError
        switch networkError.code {
        case NSURLErrorNotConnectedToInternet:
            return .networkFailure
        case NSURLErrorTimedOut:
            return .timeout
        default:
            return .unknown
        }
    }
    
    /// Maps an HTTP negative status code into an custom error enum via `NetworkError`
    private func mapHTTPStatusError(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            return .unAuthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 429:
            return .apiRateLimited
        case 503:
            return .serviceUnavailable
        case 500 ... 599:
            return .server
        default:
            return .unknown
        }
    }
}
