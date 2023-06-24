//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import SwiftUI
import SharedUtils
import DomainLayer
import DataLayer

final class NextToGoViewModel: ObservableObject {

    // MARK: - Outputs

    @Published private(set) var loadingState: CollectionLoadingState<[Race]> = .loading(placeholder: Race.placeholders)

    @ObservedObject private(set) var filterViewModel: FiltersViewModel

    private(set) var countries: [Country] = Country.allCases

    @Published var selectedCountry: String = Country.international.rawValue

    // MARK: - Dependency

    private let interactor: NextRacesInteracting

    private var cancellable: AnyCancellable?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(interactor: NextRacesInteracting = NextRacesInteractor()) {

        self.interactor = interactor

        self.filterViewModel = FiltersViewModel()

        self.filterViewModel.filterTappedAction = { [weak self] in
            self?.loadNextRaces()
        }

//        $selectedCountry
//            .dropFirst()
////            .removeDuplicates()
////            .SwitchToLatest()
//            .sink { [unowned self] _ in
//                loadNextRaces()
//            }
//            .store(in: &cancellables)
    }

    deinit {
        cancellable?.cancel()
        cancellable = nil
    }

    // MARK: - API methods

    /// Load the next races. (Currently loads next 5)
    func loadNextRaces() {

        cancellable?.cancel()

        let filteredCategories = filterViewModel.filters
            .filter { $0.selected }
            .map { $0.category }

        // Note:🤚🏽🤚🏽 As per business need, load 5 races.
        // Update this value below to load 10 or as many
        // as you like. 🤩

        // ALSO UPDATE THE NEGATIVE TOLERANCE from -90s to -180s or
        // even more to show how much older ones you want the users to show
        // Neds, Ladbrokes app shows up to minus 3 or 4 minutes.

        cancellable = $selectedCountry
            .removeDuplicates()
            .setFailureType(to: NetworkError.self)
            .flatMapLatest { [unowned self] countryCode in

                // For 🌏 `INTL` country code means international
                // We pass `nil`, as if no specific country is needed
                // to be filtered.
                // Means entire globe combined all possible countries,
                // a truly international racing experience. 🌐

                var country: String?
                if countryCode != Country.international.rawValue {
                    country = countryCode
                }

                return interactor
                    .nextRaces(
                        forCategories: filteredCategories,
                        andCountry: country,        // Pass the specific country of interest (if any)
                        numberOfRaces: 5,           // Load the top 5 only
                        hardNegativeTolerance: -90  // Up to -90 seconds older allowed to show on UI
                    )
            }

            // FIXME: ‼️ Tweak this 1.0 delay below ‼️
            // Helps in shimmering to show always for a bit.
            // Else it can be too quick and looks glitchy.
            // Consult with UX team and find the correct value.
            // Perhaps 0.5 seconds quick shimmer should be enough. 🤩

            .delay(for: .seconds(1.0), scheduler: Scheduler.main)

            .mapToLoadingState(placeholder: Race.placeholders)
            .receive(on: Scheduler.main)
            .assign(to: \.loadingState, on: self)
    }

    // MARK: - Computed properties

    var title: String {
        "next.togo.races.title".l10n()
    }

    var navBarHeroIcon: String {
        "figure.equestrian.sports"
    }

    var refreshButtonIcon: String {
        "arrow.clockwise.circle"
    }

    var refreshButtonTitle: String {
        "next.togo.races.refresh.button.title".l10n()
    }

    var refreshButtonAccessibilityHint: String {
        "next.togo.races.refresh.button.accessibility.hint".l10n()
    }

    var settingsButtonIcon: String {
        "slider.horizontal.3"
    }

    var settingsButtonTitle: String {
        "next.togo.races.settings.button.title".l10n()
    }

    var settingsButtonAccessibilityHint: String {
        "next.togo.races.settings.button.accessibility.hint".l10n()
    }

    var emptyListIcon: String {
        "cloud.moon.rain"
    }

    var emptyListTitle: String {
        "next.togo.races.empty.title".l10n()
    }

    var emptyListMessage: String {
        "next.togo.races.empty.message".l10n()
    }

}

// MARK: - Shimmer placeholders helper

private extension Race {

    static var placeholders: [Race] {
        var list: [Race] = []
        for idx in 1...5 {
            list.append(
                Race(
                    id: "\(idx)",
                    category: .horse,
                    name: "Lorem ipsum dolor",
                    number: "9",
                    meeting: "Lorem ipsum",
                    startTime: Date.now,
                    venu: .init(state: "QLD", country: "AUS")
                )
            )
        }
        return list
    }
}

enum Country: String, CaseIterable, Identifiable {

    var id: String { rawValue }

    /// Used as helper to combine all countries internally
    /// and treat that as an item in the picker to select
    case international = "INTL"

    case aus =  "AUS"
    case nz =   "NZL"
    case jpn =  "JPN"
    case uk =   "GBR"
    case fra =  "FRA"
    case brz =  "BRA"
    case usa =  "USA"

    var name: String {
        switch self {
        case .international:    return "INTL"
        case .aus:              return "Australia"
        case .nz:               return "New Zealand"
        case .jpn:              return "Japan"
        case .uk:               return "United Kingdom"
        case .fra:              return "France"
        case .brz:              return "Brazil"
        case .usa:              return "USA"
        }
    }

    var displayName: String {
        if self == .international {
            return "🌏" + " " + name
        }
        return (CountryUtilities.countryFlag(byAlphaCode: self.rawValue) ?? "") + " " + name
    }

}
