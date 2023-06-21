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
        numberOfRaces count: Int,
        hardNegativeTolerance tolerance: TimeInterval? = nil
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {

        // 🤚🏽🤚🏽
        // Always try to load 50 races at once, but then later filter out based
        // on the exact need by category and number of races to show on UI.

        // Perhaps not the best practice to load such heavy volume of data
        // in REST JSON api pattern. GraphQL comes handy here to filter out
        // necessary sub-properties of data from a huge list to load faster
        // and save network data bandwidth.
        // 🤚🏽🤚🏽

        // Fire every 5 min to load the full set of raw data from Backend API

        let nextRacesFullListPublisher = Timer.publish(
            every: 5 * 60,
            on: .main,
            in: .common
        )
            .autoconnect()
            .prepend(Date.now)    // Necessary to fire one instantly at start
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
            .flatMapLatest { [unowned self] _ in
                networkService.load(
                    Resource<RacesListResponse>.nextRaces(numberOfRaces: 50)
                )
                    .compactMap { response in
                        // 1. Map the raw data layer models to domain layer models
                        // 2. remove any duplicate items just in case (if possible via API)
                        Array(Set(response.races))
                            .compactMap { Race(from: $0) }
                    }
            }
            .eraseToAnyPublisher()

        // Fire an another timer every 55 seconds to achieve the freshness of data
        // from the previous publisher (which polls the full list from network every
        // 5 minutes only)
        return Timer.publish(every: 55, on: .main, in: .common)
            .autoconnect()
            .prepend(Date.now) // Necessary to fire one instantly at start
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
            .flatMapLatest { _ in
                nextRacesFullListPublisher
                    .map { allRaces in

                        // 3. Filter & combine based on desired categories needed and crate a big list
                        // 4. Remove any item whole advertised start_time is beyond 90sec in minus
                        // 5. Sort based on time ascending from the list
                        // 6. Take the first required number of races from the full list

                        // This above logic matches precisely with Neds / Ladbrokes apps
                        // filter logic. To show the top 5 races after ✅ filters.

                        // ‼️ However, those apps allow up to minus few minutes in the past
                        // but here in this app we are doing up to 🚨 -tolerance 🚨 seconds ‼️

                        var results: [Race] = []
                        categories.forEach { category in
                            results.append(
                                contentsOf: allRaces.filter { $0.category == category }
                            )
                        }

                        let sortedTopRaces = results
                            .filter { race in
                                guard let tolerance else { return true }
                                let timeLeft = race.startTime.timeIntervalSinceNow
                                return timeLeft > tolerance
                            }
                            .sorted {  $0.startTime <= $1.startTime }
                            .prefix(count)

                        return Array(sortedTopRaces)
                    }
            }
            .eraseToAnyPublisher()
    }

}
