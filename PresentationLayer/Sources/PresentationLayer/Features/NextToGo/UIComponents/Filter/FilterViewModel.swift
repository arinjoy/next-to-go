//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import SwiftUI
import SharedUtils
import DomainLayer

struct FilterModel: Identifiable {
    var id: Int
    var category: Race.Category
    var selected: Bool
}

final class FilterViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var filters: [FilterModel] = [
        FilterModel(id: 0, category: .horse, selected: true),
        FilterModel(id: 1, category: .greyhound, selected: true),
        FilterModel(id: 2, category: .harness, selected: true),
    ]
    
    var filterTappedAction: (() -> (Void))? = nil
    
    // MARK: - Initializer
    
    init() { }
    
    // MARK: - API
    
    func filterItemTapped(filterItem item: FilterModel) {
        filters[item.id].selected.toggle()
        
        if filters.allSatisfy({ $0.selected == false }) {
            resetFilters()
        }
        
        filterTappedAction?()
    }
    
    // MARK: - Private
    
    private func resetFilters() {
        for item in filters {
            filters[item.id].selected.toggle()
        }
    }
}

extension Race.Category {
    
    var accessibilityLabel: String {
        switch self {
        case .horse:      return "next.togo.races.filter.horse.title".l10n()
        case .greyhound:  return "next.togo.races.filter.greyhound.title".l10n()
        case .harness:    return "next.togo.races.filter.harness.title".l10n()
        }
    }

}
