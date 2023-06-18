//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import DomainLayer
import SharedUtils
import Combine

public struct NextToGoView: View {
    
    @State private var horseSelected: Bool = true
    @State private var greyhoundSelected: Bool = true
    @State private var harnessSelected: Bool = true
    
    @ObservedObject private var viewModel: NextToGoViewModel
    
    @ObservedObject private var filterViewModel: FilterViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.viewModel = NextToGoViewModel()
        self.filterViewModel = FilterViewModel()
    }
    
    public var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 20) {
                
                if viewModel.raceItems != nil {
                    
                    FilterView(viewModel: filterViewModel)
                    
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
                    //.padding(.top, 20)
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
