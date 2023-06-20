//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import Combine
import SharedUtils
import DataLayer

// MARK: - Interactor Spy

public final class NextRacesInteractorSpy: NextRacesInteracting {

    // Spied calls
    public var nextRacesCalled: Bool = false

    public func nextRaces(
        for categories: [Race.Category],
        numberOfRaces count: Int
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {
        nextRacesCalled = true
        return .just([]).eraseToAnyPublisher()
    }
}

// MARK: - Interactor Mock

public final class NextRacesInteractorMock: NextRacesInteracting {

    public var returningError: Bool
    public var error: NetworkError
    public var resultingData: [Race]

    init(
        returningError: Bool = false,
        error: NetworkError = NetworkError.unknown,
        resultingData: [Race] = NextRacesInteractorMock.sampleRaces
    ) {
        self.returningError = returningError
        self.error = error
        self.resultingData = resultingData
    }

    public func nextRaces(
        for categories: [Race.Category],
        numberOfRaces count: Int
    ) -> AnyPublisher<[Race], DataLayer.NetworkError> {
        if returningError {
            return .fail(error)
        }
        return .just(resultingData).eraseToAnyPublisher()
    }

    public static var sampleRaces: [Race] {
        TestHelper.sampleRacesList.races.compactMap { Race(from: $0) }
    }
}
