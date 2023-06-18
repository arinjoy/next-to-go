//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct FilterModel: Identifiable {
    var id: Int
    var category: Race.Category
    var selected: Bool
}

class FilterViewModel: ObservableObject {
    
    @Published var filters: [FilterModel] = [
        FilterModel(id: 0, category: .horse, selected: true),
        FilterModel(id: 1, category: .greyhound, selected: true),
        FilterModel(id: 2, category: .harness, selected: true),
    ]
    
    init() { }
    
    func filterRowTapped(filterRow: FilterModel) {
        filters[filterRow.id]
            .selected
            .toggle()
    }
    
    func filterReset() {
        for element in filters {
            if element.selected {
                filterRowTapped(filterRow: element)
            }
        }
    }
}

struct FilterView: View {
    
    @StateObject var viewModel: FilterViewModel
    
    var body: some View {
        
        HStack {
            
            ForEach(viewModel.filters) { filter in
                
                HStack(spacing: 10) {
                    
                    Image(filter.category.iconName, bundle: .module)
                        .font(.largeTitle)
                        .scaleEffect(1.3)
         
                    Image(systemName: filter.selected ?
                          "checkmark.circle.fill" : "circle")
                    .font(.body)
                        .onTapGesture {
                            viewModel.filterRowTapped(filterRow: filter)
                        }
                }
                .foregroundColor(filter.selected ? .red : .primary)
                .adaptiveScaleFactor()
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: filter.selected ?
                                    .red.opacity(0.5) : .primary.opacity(0.5),
                                radius: 2.5,
                            x: 0, y: 0))
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.filterRowTapped(filterRow: filter)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityAddTraits(.isButton)
                .accessibilityAddTraits(filter.selected ? .isSelected : .isButton)
            }
        }
        .padding(.horizontal, 10)
        
        Divider()
    }
}


#if DEBUG
struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewModel: FilterViewModel())
            .padding(.bottom, 300)
    }
}
#endif
