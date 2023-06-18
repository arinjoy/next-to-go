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
        for category: Race.Category? = nil,   // Defaults to `nil` means all races combined
        pollEvery interval: TimeInterval = 30  // Defaults to 30 seconds polling
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {
                
        var targetCategoryId: String?
        if let category {
            targetCategoryId = category.rawValue
        }
        
        let nextRacesPublisher = networkService.load(
            Resource<RacesListResponse>.nextRaces(forCategory: targetCategoryId)
        )
            .compactMap {
                $0.races.compactMap { Race(from: $0) }
                    .sorted {  $0.startTime < $1.startTime }
            }
        
        return Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .prepend(Date.now) // Prepends necessary to fire instantly at start
            .setFailureType(to: NetworkError.self) // To compose with nextRaces publisher type
            .eraseToAnyPublisher()
            .flatMapLatest { _ in
                nextRacesPublisher
            }
            .eraseToAnyPublisher()
    }
    
}
