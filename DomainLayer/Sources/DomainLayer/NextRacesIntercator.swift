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
    
    public func nextRaces(
        for category: Race.Category = .all,   // Defaults to all races
        pollEvery interval: TimeInterval = 5  // Defaults to 5 seconds polling
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {
        
       let timer = Timer.publish(every: interval, on: .main, in: .common)
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
        
        let nextRacesPublisher = networkService.load(
            Resource<RacesListResponse>.nextRaces(forCategory: targetCategoryId)
        )
            .compactMap { $0.races.compactMap { Race(from: $0) } }
   
        
        return Publishers.CombineLatest(timer, nextRacesPublisher)
            .map { _, results in
                return results
            }
            .eraseToAnyPublisher()
    }
    
}
