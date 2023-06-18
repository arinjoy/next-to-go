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
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    public init() {
        self.viewModel = NextToGoViewModel()
    }
    
    // MARK: - UI Body
    
    public var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 20) {
                
                if viewModel.raceItems != nil {
                    
                    FilterView(viewModel: viewModel.filterViewModel)
                    
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.loadNextRaces()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.primary)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("Refresh")
                    }
                }
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading) {
                        Text("Next to Go")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .accessibilityAddTraits(.isHeader)
                    }
                }
            }
            .padding(.top, 20)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadNextRaces()
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
