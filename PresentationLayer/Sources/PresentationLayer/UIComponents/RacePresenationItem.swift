//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import Combine
import DomainLayer

class RacePresentationItem: ObservableObject {

    // MARK: - Properties
    
    let race: Race

    @Published var timeString: String?
    
    var iconName: String {
        switch race.category {
        case .horse:        return "tortoise"
        case .greyhound:    return "hare"
        case .harness:      return "bird"
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
