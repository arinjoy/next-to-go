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
            .nextRaces(for: nil, pollEvery: 30)
            .receive(on: Scheduler.main)
            // TODO: remove forced delay
            .delay(for: .seconds(1), scheduler: Scheduler.main)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    isLoading = false
                    loadingError = error
                }
            } receiveValue: { [unowned self] results in
                isLoading = false
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



