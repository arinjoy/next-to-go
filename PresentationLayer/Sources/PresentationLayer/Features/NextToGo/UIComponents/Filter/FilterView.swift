//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct FilterView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: FilterViewModel
    
    // TODO: Test more and find the perfect haptic you need. 💗
    let haptic = UIImpactFeedbackGenerator(style: .heavy)
    
    // MARK: - UI Body
    
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
                }
                .accessibilityElement(children: .combine)
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
                    haptic.impactOccurred()
                    viewModel.filterItemTapped(filterItem: filter)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(filter.category.accessibilityLabel)
                .accessibilityHint(
                    filter.category.accessibilityHint(selected: filter.selected)
                )
                .accessibilityAddTraits(filter.selected ?
                                        [.isButton, .isSelected] : .isButton)
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
