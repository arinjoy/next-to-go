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

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    public init() {
        self.viewModel = NextToGoViewModel()
    }

    // MARK: - UI Body

    public var body: some View {

        NavigationView {

            VStack(alignment: .center, spacing: 10) {

                FiltersView(viewModel: viewModel.filterViewModel)

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
            .navigationBarTitle(Text(viewModel.title), displayMode: .large)
            .toolbar { toolBarContent }
            .padding(.top, 20)
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
                viewModel.loadNextRaces()
            } label: {
                Image(systemName: viewModel.refreshButtonIcon)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.refreshButtonTitle)
                    .accessibilityHint(viewModel.refreshButtonAccessibilityHint)
            }
        }

        ToolbarItem(placement: .principal) {
            Image(systemName: viewModel.navBarHeroIcon)
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.red)
                .accessibilityHidden(true)
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
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.settingsButtonTitle)
                    .accessibilityHint(viewModel.settingsButtonAccessibilityHint)
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }
}

#if DEBUG
struct NextToGoView_Previews: PreviewProvider {
    static var previews: some View {
        NextToGoView()
    }
}
#endif
