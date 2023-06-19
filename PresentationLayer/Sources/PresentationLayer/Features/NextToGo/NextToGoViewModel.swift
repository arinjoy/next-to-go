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
    
    @Published var raceItems: [Race]?
    @Published var isLoading: Bool = false
    @Published var loadingError: NetworkError?
    
    @ObservedObject var filterViewModel: FilterViewModel

    // MARK: - Private Properties
    
    private let interactor: NextRacesInteracting
    private var cancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    
    init(interactor: NextRacesInteracting = NextRacesInteractor()) {
        
        self.interactor = interactor
        
        self.filterViewModel = FilterViewModel()
        
        self.filterViewModel.filterTappedAction = { [weak self] in
            self?.loadNextRaces()
        }
    }
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
    }
    
    // MARK: - API methods
    
    func loadNextRaces() {
        
        cancellable?.cancel()

        raceItems = nil
        isLoading = true
        
        let filteredCategories = filterViewModel.filters
            .filter { $0.selected }
            .map { $0.category }
        
        
        // Note: Get the latest 5 races only (not more) as per business requirement
        
        cancellable = interactor
            .nextRaces(for: filteredCategories, numberOfRaces: 5)
            .receive(on: Scheduler.main)
        
            // Increase this to debug delayed loading
            .delay(for: .seconds(0.2), scheduler: Scheduler.main)
        
            .sink { [unowned self] completion in
                isLoading = false
                if case .failure(let error) = completion {
                    loadingError = error
                }
            } receiveValue: { [unowned self] results in
                isLoading = false
                raceItems = results
            }
    }
    
    // MARK: - Localized Copies
    
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
    
}
