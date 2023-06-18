//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import Combine
import DomainLayer

class RacePresentationItem: ObservableObject {

    // MARK: - Properties
    
    private let race: Race
    
    @Published var timeString: String?
    
    var number: String {
        race.number
    }
    
    var name: String {
        race.meeting
    }
    
    var description: String {
        race.name
    }
    
    var country: String {
        race.venu.country
    }
    
    var iconName: String {
        race.category.iconName
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(race: Race) {
        self.race = race
        
        Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .prepend(Date.now)
            .sink { [weak self] _ in
                self?.timeString = race.startTime.timeIntervalSinceNow
                    .minutesSecondsLeft()
            }
            .store(in: &cancellables)
    }
    
}

extension Race.Category {
    
    var iconName: String {
        /// Currently `horse` and  `greyhound` are custom SF symbols converted
        /// after copying from SVG files from online free source and imported via the Image Symbol.
        /// `harness` was made by exporting Apple's figure sport icon and mixing with other shapes. :)
        
        switch self {
        case .horse:        return "horse"        // Hand-made SF symbol
        case .greyhound:    return "greyhound"    // Hand-made SF symbol
        case .harness:      return "harness"      // Hand-made SF symbol
        }
    }
}


extension TimeInterval {

    func minutesSecondsLeft() -> String {
        let time = NSInteger(self)

        let minutes = (time / 60) % 60
        let seconds = time % 60
     
        if minutes == 0 {
            return String(format: "%0.1ds", seconds)
        }
        
        return String(format: "%0.1dm %0.1ds", minutes, seconds)
    }

}
