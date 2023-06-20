//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct FiltersView: View {

    // MARK: - Properties

    @StateObject var viewModel: FiltersViewModel

    // NOTE: 💗 Test more and find the perfect haptic feelings you need. 💗
    let haptic = UIImpactFeedbackGenerator(style: .heavy)

    // MARK: - UI Body

    var body: some View {

        HStack {

            ForEach(viewModel.filters) { filter in

                HStack(spacing: 10) {

                    Image(filter.category.iconName, bundle: .module)
                        .font(.largeTitle)
                        .scaleEffect(1.4)

                    Image(systemName: filter.selected ?
                          "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .scaleEffect(1.1)
                }
                .accessibilityElement(children: .combine)
                .foregroundColor(filter.selected ? .red : .primary)
                .adaptiveScaleFactor()
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: filter.selected ?
                                    .red.opacity(0.5) : .primary.opacity(0.3),
                                radius: 3,
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
            .padding(.top, 8)

    }
}

#if DEBUG
struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(viewModel: FiltersViewModel())
            .padding(.bottom, 300)
    }
}
#endif
