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
    
    var iconName: String {
        switch race.category {
        case .horse:        return "horse"      // Currently custom SF symbol converted
        case .greyhound:    return "greyhound"  // after copying from SVG files from flatIcons.
        case .harness:      return "harness"    // Needs to update if Apple provides free ones.
        default:            return ""
        }
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
