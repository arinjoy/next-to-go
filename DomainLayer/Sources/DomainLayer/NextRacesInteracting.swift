//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import DataLayer

public protocol NextRacesInteracting: AnyObject {

    ///
    /// Gets the latest next x number races live and poll through it.
    /// ‼️ This publisher would create a continuous subscription that would  never stop emitting
    /// as long as it being subscribed and not being cancelled by the consumer. This would poll
    /// through the next possible x number of races to fetch the data  and re-publish the fetched results. ‼️
    /// - Parameters:
    ///   - categories: The array of categories (of races) to find latest races happening.
    ///   - country: The specific country (3 letter alpha code) of interest to filter races.
    ///   Pass `nil` to not filter any, means the outcome is international.
    ///   - count: The number of races to return based on the categories provided.
    ///   This is used to configure the desired number of top races from the list.
    ///   - tolerance: The optional hard tolerance (in time interval seconds)  to 100% remove
    ///   any races which are beyond past this (in negative) value.
    /// - Returns: A publisher that repeatedly emits the latest races reactively.
    ///
    func nextRaces(
        forCategories categories: [Race.Category],
        andCountry country: String?,
        numberOfRaces count: Int,
        hardNegativeTolerance tolerance: TimeInterval?
    ) -> AnyPublisher<[Race], DataLayer.NetworkError>

}
