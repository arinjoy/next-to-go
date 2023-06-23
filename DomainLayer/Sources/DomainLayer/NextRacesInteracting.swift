//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import DataLayer

public protocol NextRacesInteracting: AnyObject {

    ///
    /// Gets the latest next x number races live and poll through it.
    /// ‼️ This publisher would create a continuous subscription that would
    /// never stop emitting as long as it being subscribed and not being
    /// cancelled by the consumer. This would poll through the next possible
    /// x number of races to fetch the data  and re-publish the fetched results. ‼️
    /// - Parameters:
    ///   - categories: The array of categories (of races) to find.
    ///   - count: The  number of races to find based on the categories provided.
    ///   - tolerance: The optional hard tolerance (in time interval seconds)  to 100%
    ///   remove any race which are beyond past this (in negative) value.
    /// - Returns: A publisher that repeatedly emits the found races.
    ///
    func nextRaces(
        for categories: [Race.Category],
        numberOfRaces count: Int,
        hardNegativeTolerance tolerance: TimeInterval?
    ) -> AnyPublisher<[Race], DataLayer.NetworkError>

}
