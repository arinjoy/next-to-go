//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import Combine
import Foundation

enum CollectionLoadingState<Content> {
    case loading(placeholder: Content)
    case loaded(content: Content)
    case empty
    case error(Error)
}

extension Publisher where Output: Collection {
    
    func mapToLoadingState(
        placeholder: Output
    ) -> AnyPublisher<CollectionLoadingState<Output>, Never> {
        map {
            $0.isEmpty ? CollectionLoadingState.empty : .loaded(content: $0)
        }
        .catch {
            Just(CollectionLoadingState.error($0))
        }
        .prepend(.loading(placeholder: placeholder))
        .eraseToAnyPublisher()
    }
    
}

