//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import Foundation
import Combine
@testable import DataLayer

final class NetworkServiceSpy: NetworkServiceType {

    // Spy calls
    var loadReSourceCalled = false

    // Spy values
    var url: URL?
    var parameters: [String: CustomStringConvertible]?
    var request: URLRequest?
    var isLocalStub: Bool?

    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {

        loadReSourceCalled = true

        url = resource.url
        parameters = resource.parameters
        request = resource.request
        isLocalStub = resource.isLocalStub

        return Empty().eraseToAnyPublisher()
    }
}

final class NetworkServiceMock<ResponseType>: NetworkServiceType {

    /// The pre-determined response to always return from this mock no matter what request is made
    let response: ResponseType

    /// Whether to return error outcome
    let returningError: Bool

    /// The pre-determined error to return if `returnError` is set true
    let error: NetworkError

    init(response: ResponseType,
         returningError: Bool = false,
         error: NetworkError = NetworkError.unknown
    ) {
        self.response = response
        self.returningError = returningError
        self.error = error
    }

    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {

        if returningError {
            return .fail(error)
        }

        return .just(response as! T) // swiftlint:disable:this force_cast
    }
}
