//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import Combine
import SharedUtils
import DomainLayer
import DataLayer

class NextToGoViewModel: ObservableObject {
    
    // MARK: - Outputs
    
    @Published var raceItems: [Race]?
    @Published var isLoading: Bool = false
    @Published var loadingError: NetworkError?

    // MARK: - Private Properties
    
    private let interactor: NextRacesInteracting
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(interactor: NextRacesInteracting = NextRacesInteractor()) {
        self.interactor = interactor
    }
    
    // MARK: - API
    
    func loadNextRaces() {
        
        raceItems = nil
        isLoading = true
        
        interactor
            .nextRaces(for: .all, pollEvery: 5)
            .receive(on: Scheduler.main)
            .sink { [unowned self] completion in
                isLoading = false
                if case .failure(let error) = completion {
                    loadingError = error
                }
            } receiveValue: { [unowned self] results in
                raceItems = results
                
                // FIXME: Remove testing code
                let names = results.map {
                    return $0.name
                }
                print("\n\n------------>")
                print(names)
            }
            .store(in: &cancellables)
    }
    
}



