//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import DataLayer

public protocol NextRacesInteracting: AnyObject {
    
    ///
    /// Gets the latest next 5 races live and poll through it. This publisher would create
    /// an continuous subscription that would never stop emitting as long as it being subscribed
    /// and not being cancelled by the consumer. This would poll through the latest possible 5 races
    /// to fetch the data every 1 minute and re-publish the results
    /// - Returns: A array of `Race` objects in the form of `AnyPublisher`
    ///
    func nextFiveRaces(for category: Race.Category) -> AnyPublisher<[Race], DataLayer.NetworkError>
}

