//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import Combine
import SharedUtils
import DomainLayer

final class RacePresentationItem: ObservableObject {

    // MARK: - Properties
    
    private let race: Race
    
    @Published var timeString: String?
    
    var number: String {
        "R\(race.number)"
    }
    
    var name: String {
        race.meeting.trimmed()
    }
    
    var description: String {
        race.name.trimmed()
    }
    
    var countryEmoji: String? {
        CountryUtilities.countryFlag(byAlphaCode: race.venu.country)
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
                    .hoursMinutesSeconds()
            }
            .store(in: &cancellables)
    }
    
}

extension Race.Category {
    
    var iconName: String {
        
        /// Currently these are all custom SF symbols converted after copying
        /// from SVG files from online free sources and then edited via Sketch.app.
        /// Thereafter imported as the Symbol Image Asset in Xcode's Image Assets.
        /// Xcode can read these symbols and treat like any other standard SF symbols.
        /// https://developer.apple.com/documentation/uikit/uiimage/creating_custom_symbol_images_for_your_app

        switch self {
        case .horse:        return "horse"        // Hand-made SF symbol
        case .greyhound:    return "greyhound"    // Hand-made SF symbol
        case .harness:      return "harness"      // Hand-made SF symbol
        }
    }
}


extension TimeInterval {

    /// Returns a formatted string from hour minute seconds left
    /// Example: `5h` `2h` `18m` `3m``1m 20s`  `17s` `5s` etc.
    func hoursMinutesSeconds() -> String {
        let time = NSInteger(self)

        let hours = (time / 60 / 60) % 60
        let minutes = (time / 60) % 60
        let seconds = time % 60
        
        // TODO: Needs more tweaking and unit testing every combination

        if hours >= 1 {
            return String(format: "%0.1dh", hours)
        }
        
        if minutes >= 3 {
            return String(format: "%0.1dm", minutes)
        }
        
        if minutes == 0 {
            return String(format: "%0.1ds", seconds)
        }
        
        return String(format: "%0.1dm %0.1ds", minutes, seconds)
    }

}
