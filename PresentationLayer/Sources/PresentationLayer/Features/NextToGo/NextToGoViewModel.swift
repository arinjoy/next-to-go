//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import SwiftUI
import SharedUtils
import DomainLayer

final class NextToGoViewModel: ObservableObject {
    
    // MARK: - Outputs
    
    @Published private(set) var loadingState: CollectionLoadingState<[Race]> = .loading(placeholder: Race.placeholders)
    
    @ObservedObject private(set) var filterViewModel: FiltersViewModel

    // MARK: - Dependency
    
    private let interactor: NextRacesInteracting
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    
    init(interactor: NextRacesInteracting = NextRacesInteractor()) {
        
        self.interactor = interactor
        
        self.filterViewModel = FiltersViewModel()
        self.filterViewModel.filterTappedAction = { [weak self] in
            self?.loadNextRaces()
        }
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
                
        cancellable = interactor
            .nextRaces(for: filteredCategories, numberOfRaces: 5)
            // TODO: ‼️ Tweak this 1.0 delay below. Helps in shimmering. ‼️
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
    
    var emptyListTilte: String {
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
