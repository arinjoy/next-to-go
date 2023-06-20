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

                // 1. Map the raw data layer models to domain layer models
                // 2. Filter & combine based on desired categories needed and crate a big list
                // 3. Sort based on time ascending from the big list
                // 4. Take the first required number of races from the full list

                // This above logic matches precisely with Neds / Ladbrokes apps
                // filter logic. To show the top 5 races after ✅ filters.

                // Remove any duplicates (if possible via API)
                let allRaces = Array(Set(response.races))
                    .compactMap { Race(from: $0) }

                var results: [Race] = []
                categories.forEach { category in
                    results.append(
                        contentsOf: allRaces.filter { $0.category == category }
                    )
                }

                let sortedTopRaces = results
                    .sorted {  $0.startTime < $1.startTime }
                    .prefix(count)

                return Array(sortedTopRaces)
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
