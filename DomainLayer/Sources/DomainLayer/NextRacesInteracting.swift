//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import DataLayer

public protocol NextRacesInteracting: AnyObject {
    
    ///
    /// Gets the latest next 5 races live and poll through it. This publisher would create a continuous
    /// subscription that would never stop emitting as long as it being subscribed and not being
    /// cancelled by the consumer. This would poll through the latest possible 5 races
    /// to fetch the data on the provided interval and re-publish the fetched results.
    /// - Parameters:
    ///   - category: The category of races to find.
    ///   - interval: The time interval (in seconds) on which to poll.
    /// - Returns: A publisher that repeatedly emits the found races in the given interval.
    ///
    func nextRaces(
        for category: Race.Category,
        pollEvery interval: TimeInterval
    ) -> AnyPublisher<[Race], DataLayer.NetworkError>
    
}
