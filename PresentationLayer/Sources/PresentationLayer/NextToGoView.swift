//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import DomainLayer
import SharedUtils
import Combine

public struct NextToGoView: View {
    
    @ObservedObject private var viewModel: NextToGoViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.viewModel = NextToGoViewModel()
    }
    
    public var body: some View {
        
        NavigationStack {
            
            Group {
                
                Spacer().frame(height: 20)
                
                if viewModel.raceItems != nil {
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
                
                ToolbarItem(placement: .principal) {
                    
                    VStack {
                    
                        Text("Next to Go")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .accessibilityAddTraits(.isHeader)
                        
                        HStack(spacing: 16) {
                            ForEach(Race.Category.allCases, id: \.rawValue) {
                                Image($0.iconName, bundle: .module)
                                    .font(.title)
                                    .foregroundColor(.primary)
                            }
                        }
                        .accessibilityHidden(true)
                    }
                    .padding(.top, 20)
                }
            }
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
