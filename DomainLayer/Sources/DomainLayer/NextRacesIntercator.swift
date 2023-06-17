//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import SharedUtils
import DataLayer

public final class NextRacesInteractor: NextRacesInteracting {
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependency
    
    private let networkService: NetworkServiceType
    
    // MARK: - Initializer
    
    public init(networkService: NetworkServiceType = ServicesProvider.defaultProvider().network) {
        self.networkService = networkService
    }
    
    // MARK: - NextRacesInteracting
    
    public func nextFiveRaces(for category: Race.Category) -> AnyPublisher<[Race], DataLayer.NetworkError> {
        
       let timer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .prepend(Date.now)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        
        var targetCategoryId: String?
        if case .all = category {
            targetCategoryId = nil
        } else {
            targetCategoryId = category.rawValue
        }
        
        let nextFivePublisher = networkService.load(
            Resource<RacesListResponse>.nextFiveRaces(forCategory: targetCategoryId)
        )
            .compactMap { $0.races.compactMap { Race(from: $0) } }
   
        
        return Publishers.CombineLatest(timer, nextFivePublisher)
            .map { _, results in
                return results
            }
            .eraseToAnyPublisher()
    }
    
}
