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

    /// NOTE: 🤚🏽 Use the provider which is the default as in below.
    /// During debugging / testing use the `localStubbedProvider()`
    /// not not hit the real network and get locally stubbed JSON :)
    public init(
        networkService: NetworkServiceType = ServicesProvider.defaultProvider().network
    ) {
        self.networkService = networkService
    }
    
    // MARK: - NextRacesInteracting
    
    public func nextRaces(
        for categories: [Race.Category],
        numberOfRaces count: Int
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {
        
        // ‼️🤚🏽‼️🤚🏽‼️🤚🏽‼️🤚🏽‼️🤚🏽‼️🤚🏽
        // Always try to load 45 races at once, but then later filter out based
        // on the exact need by category and number of races to show on UI.
        
        // Perhaps not the best practice to load such heavy volume of data
        // in REST JSON api pattern. GraphQL comes handy here to filter out
        // necessary sub-properties of data from a huge list to load faster
        // and save network data bandwidth.
        // ‼️🤚🏽‼️🤚🏽‼️🤚🏽‼️🤚🏽‼️🤚🏽‼️🤚🏽
        
        let nextRacesPublisher = networkService.load(
            Resource<RacesListResponse>.nextRaces(numberOfRaces: 45)
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
        
        // Poll every 30 seconds to refresh latest races
        return Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .prepend(Date.now)  // Necessary to fire instantly at start
            .setFailureType(to: NetworkError.self) // To compose with nextRaces publisher
            .eraseToAnyPublisher()
            .flatMapLatest { _ in
                nextRacesPublisher
            }
            .eraseToAnyPublisher()
    }
    
}
