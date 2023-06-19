//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine

/// This is a stub implementation of `NetworkServiceType` to fetch data locally from JSON file after 2 seconds delay
final class LocalStubbedDataService: NetworkServiceType {

    private let localFileName: String

    init(withLocalFile fileName: String) {
        self.localFileName = fileName
    }

    // MARK: - NetworkServiceType

    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, NetworkError> {
        let future = Future<T, NetworkError> { [weak self] promise in
            guard let strongSelf = self else {
                promise(.failure(.unknown))
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                if let fileURLPath = Bundle.module.url(
                    forResource: strongSelf.localFileName,
                    withExtension: "json",
                    subdirectory: "JSON") {

                    do {
                        let data = try Data(contentsOf: fileURLPath)
                        let jsonDecoder = JSONDecoder()
                        let decoded = try jsonDecoder.decode(T.self, from: data)
                        promise(.success(decoded))
                    } catch {
                        promise(.failure(.jsonDecodingError(error: error)))
                    }
                } else {
                    promise(.failure(.unknown))
                }
            }
        }
        return future.eraseToAnyPublisher()
    }
}
