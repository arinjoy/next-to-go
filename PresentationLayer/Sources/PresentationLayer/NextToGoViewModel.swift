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
    
    // MARK: - Initializer
    
    init(interactor: NextRacesInteracting = NextRacesInteractor()) {
        
        self.interactor = interactor
        
        self.filterViewModel = FilterViewModel()
        
        self.filterViewModel.filterTappedAction = { [weak self] in
            self?.loadNextRaces()
        }
    }
    
    // MARK: - API methods
    
    func loadNextRaces() {
        
        cancellable?.cancel()

        raceItems = nil
        isLoading = true
        
        let filteredCategories = filterViewModel.filters
            .filter { $0.selected }
            .map { $0.category }
        
        cancellable = interactor
            .nextRaces(for: filteredCategories, numberOfRaces: 5)
            .receive(on: Scheduler.main)
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
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
    }
    
}



