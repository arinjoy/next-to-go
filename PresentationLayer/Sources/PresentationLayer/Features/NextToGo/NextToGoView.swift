//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import Combine
import DataLayer
import SharedUtils

public struct NextToGoView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: NextToGoViewModel

    @State private var isShowingSettings: Bool = false

    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    @AppStorage("isDarkMode") private var isDarkMode = false

    @Environment(\.sizeCategory) private var sizeCategory

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    public init() {
        self.viewModel = NextToGoViewModel()
    }

    // MARK: - UI Body

    public var body: some View {

        NavigationView {

            VStack(alignment: .center, spacing: 16) {

                headingStack
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                FiltersView(viewModel: viewModel.filterViewModel)
                    .padding(.bottom, 10)

                Divider()

                CollectionLoadingView(
                    loadingState: viewModel.loadingState,
                    content: RacesListView.init(items:),
                    empty: {
                        ErrorMessageView(
                            iconName: viewModel.emptyListIcon,
                            title: viewModel.emptyListTitle,
                            message: viewModel.emptyListMessage
                        )
                    },
                    error: {
                        if let networkError = $0 as? NetworkError {
                            ErrorMessageView(
                                iconName: networkError.iconName,
                                title: networkError.title,
                                message: networkError.message
                            )
                        } else {
                            EmptyView()
                        }
                    }
                )
            }
            .toolbar { toolBarContent }
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // link dark / light mode
        .onAppear {
            viewModel.loadNextRaces()
        }
    }
}

// MARK: - Private

private extension NextToGoView {

    @ToolbarContentBuilder
    var toolBarContent: some ToolbarContent {

        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                haptic.impactOccurred()
                viewModel.resetFiltersAndRefresh()
            } label: {
                Image(systemName: viewModel.resetFiltersIcon)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .frame(width: 28, height: 28)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.resetFiltersButtonTitle)
                    .accessibilityHint(viewModel.resetFiltersButtonAccessibilityHint)
            }
        }

        ToolbarItem(placement: .principal) {
            HStack(spacing: 10) {
                Text(viewModel.title)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)

                Image(systemName: viewModel.navBarHeroIcon)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                haptic.impactOccurred()
                isShowingSettings.toggle()
            } label: {
                Image(systemName: viewModel.settingsButtonIcon)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .frame(width: 28, height: 28)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.settingsButtonTitle)
                    .accessibilityHint(viewModel.settingsButtonAccessibilityHint)
            }
        }
    }

    @ViewBuilder
    var headingStack: some View {
        HStack(spacing: 16) {
            Spacer()
            topCountSelectionMenu
            countrySelectionMenu
        }
    }

    @ViewBuilder
    var topCountSelectionMenu: some View {
        Menu {
            Picker("", selection: $viewModel.selectedTopCount) {
                ForEach(viewModel.topCounts, id: \.self) {
                    Text("\($0)")
                }
            }
        } label: {
            menuLabel(from: "🔝 \(viewModel.selectedTopCount)")
                .accessibilityLabel(
                    // TODO: 🤓 move logic into ViewModel, use localised copy and unit test it
                    "Top \(viewModel.selectedTopCount) races"
                )
                .accessibilityAddTraits(.isSelected)
        }
        .menuSelectorStyle()
        .onTapGesture {
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
        }
    }

    @ViewBuilder
    var countrySelectionMenu: some View {
        Menu {
            Picker("", selection: $viewModel.selectedCountry) {
                ForEach(viewModel.countries) {
                    Text($0.fullDisplayName)
                }
            }
        } label: {
            if let country = Country(rawValue: viewModel.selectedCountry) {
                menuLabel(from: country.shortDisplayName)
                    .accessibilityLabel(country.name)
                    .accessibilityAddTraits(.isSelected)
            }
        }
        .menuSelectorStyle()
        .onTapGesture {
            let haptic = UIImpactFeedbackGenerator(style: .medium)
            haptic.impactOccurred()
        }
    }

    @ViewBuilder
    func menuLabel(from title: String) -> some View {

        HStack(spacing: 0) {

            Text(title)
                .lineLimit(1)
                .font(
                    sizeCategory >= .accessibilityMedium ?
                        .system(size: 24, weight: .medium, design: .rounded) :
                            .body
                )

            Spacer().frame(width: 10)

            Image(systemName: "chevron.up.chevron.down")
                .font(
                    sizeCategory >= .accessibilityMedium ?
                        .system(size: 22, weight: .medium, design: .rounded) :
                        .subheadline
                )
        }
        .foregroundColor(.red)
    }

}

// MARK: - Menu Selector Style

private extension View {

    func menuSelectorStyle() -> some View {
        self.modifier(MenuSelectorStyle())
    }

}

private struct MenuSelectorStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .adaptiveScaleFactor()
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .primary.opacity(0.25), radius: 2, x: 0, y: 0))
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
    }

}

#if DEBUG
struct NextToGoView_Previews: PreviewProvider {
    static var previews: some View {
        NextToGoView()
    }
}
#endif
