//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import DomainLayer
import SharedUtils
import Combine

public struct NextToGoView: View {
    
    // MARK: - Properties
    
    @ObservedObject private var viewModel: NextToGoViewModel
    
    @State private var isShowingSettings: Bool = false
    
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    public init() {
        self.viewModel = NextToGoViewModel()
    }
    
    // MARK: - UI Body
    
    public var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                FilterView(viewModel: viewModel.filterViewModel)
                
                if viewModel.isLoading == false {
                    RacesListView(viewModel: viewModel)
                } else {
                    LoadingView(
                        isLoading: viewModel.isLoading,
                        error: viewModel.loadingError
                    ) {
                        viewModel.loadNextRaces()
                    }
                }
            }
            .navigationBarTitle(Text("Next to Go"), displayMode: .large)
            .toolbar { toolBarContent }
            .padding(.top, 20)
        }
        .onAppear {
            viewModel.loadNextRaces()
        }
    }
}

private extension NextToGoView {
    
    @ToolbarContentBuilder
    var toolBarContent: some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                haptic.impactOccurred()
                viewModel.loadNextRaces()
            } label: {
                Image(systemName: "arrow.clockwise.circle")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Refresh")
            }
        }
        
        ToolbarItem(placement: .principal) {
            Image(systemName: "figure.equestrian.sports")
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
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Settings")
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NextToGoView()
    }
}
#endif
