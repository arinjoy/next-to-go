//
//  Created by Arinjoy Biswas on 21/6/2023.
//

import Foundation

public extension TimeInterval {

    /// Returns a formatted string from hour minute seconds left
    /// Example: `5h` `2h` `18m` `3m``1m 20s`  `17s` `5s`  `-10s` `-1m 20s`etc.
    ///
    var hoursMinutesSeconds: String {
        let time = NSInteger(self)

        let hours = (time / 60 / 60) % 60
        let minutes = (time / 60) % 60
        let seconds = time % 60

        guard hours < 2 else {
            return String(format: "%0.1dh", hours)
        }

        guard hours == 0 else {
            return String(format: "%0.1dh %0.1dm", hours, minutes)
        }

        guard minutes < 5 else {
            return String(format: "%0.1dm", minutes)
        }

        guard minutes == 0 else {

            if seconds == 0 {
                return String(format: "%0.1dm", minutes)
            }

            return String(format: "%0.1dm %0.1ds", minutes, seconds)
        }

        return String(format: "%0.1ds", seconds)
    }

    /// Should only highlight if 5 minutes or less left
    var shouldHighlight: Bool {
        let time = NSInteger(self)
        let hours = (time / 60 / 60) % 60
        let minutes = (time / 60) % 60

        return hours == 0 && minutes < 5
    }

}
