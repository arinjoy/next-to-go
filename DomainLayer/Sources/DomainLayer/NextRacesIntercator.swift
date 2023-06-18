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
        for categories: [Race.Category],
        numberOfRaces count: Int
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {
        
        // Always load 100 races first, but then later on filter out
        // based on the exact need by category and number of races to list
        let nextRacesPublisher = networkService.load(
            Resource<RacesListResponse>.nextRaces(numberOfRaces: 100)
        )
            .compactMap { response in

                // 1. Map the raw data model to domain model
                // 2. Filter based on desired categories needed
                // 3. Sort based time ascending
                // 4. Take the first required number of races from the full list

                let races = response.races
                    .compactMap { Race(from: $0) }
                    .filter { categories.contains($0.category) }
                    .sorted {  $0.startTime < $1.startTime }

                return Array(races.prefix(count))
            }
        
        // Poll every 60 seconds to refresh latest races
        return Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .prepend(Date.now)  // Necessary to fire instantly at start
            .setFailureType(to: NetworkError.self) // To compose with nextRaces publisher type
            .eraseToAnyPublisher()
            .flatMapLatest { _ in
                nextRacesPublisher
            }
            .eraseToAnyPublisher()
    }
    
}
