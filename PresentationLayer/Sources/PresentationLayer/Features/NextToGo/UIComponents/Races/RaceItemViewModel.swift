//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import Combine
import SharedUtils
import DomainLayer

final class RaceItemViewModel: ObservableObject {

    // MARK: - Properties

    private let race: Race

    @Published private(set) var countdownText: String?
    @Published private(set) var highlightCountdown: Bool = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(race: Race) {

        self.race = race

        Timer.publish(every: 1, on: RunLoop.main, in: .common)
            .autoconnect()
            .prepend(Date.now)
            .sink { [weak self] _ in
                let time = race.startTime.timeIntervalSinceNow
                self?.countdownText = time.hoursMinutesSeconds
                self?.highlightCountdown = time.shouldHighlight
            }
            .store(in: &cancellables)
    }

    // MARK: - Computed properties

    var iconName: String {
        race.category.iconName
    }

    var raceNumber: String {
        "next.togo.races.race.number.prefix".l10n() + "\(race.number)"
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

    // MARK: - Accessibility

    var combinedAccessibilityLabel: String {
        [
            race.category.accessibilityLabel,
            name,
            raceNumberAccessibilityLabel,
            countryEmoji,
            description,
            countdownTimeAccessibilityLabel
        ]
            .combinedAccessibilityLabel()
    }

    private var raceNumberAccessibilityLabel: String {
        "next.togo.races.race.number.accessibility.label".l10n() + " \(race.number)"
    }

    ///
    // TODO: 🤚🏽 Need to tweak a few things 🤚🏽

    /// To handle the singular vs. plural. Currently all singular without `s` at end when they
    /// should be. Does not sound perfect in `VoiceOver`, but manageable to understand.
    ///
    /// Also localise these components via `Localization.strings` file for non English users.
    ///
    /// And by the time user has heard this, it's too late because the timer has moved on.
    /// So the countdown value will be out of date. 😭
    /// We need a dynamic way to attach / announce the accessibility label for the cell  just
    /// for handling the count-down. Not sure if this possible by the way.
    ///
    private var countdownTimeAccessibilityLabel: String? {
        countdownText?
            .replacingOccurrences(of: "h", with: "hour")
            .replacingOccurrences(of: "m", with: "minute")
            .replacingOccurrences(of: "s", with: "second")
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
