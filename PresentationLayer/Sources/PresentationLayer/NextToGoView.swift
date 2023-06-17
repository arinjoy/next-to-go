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
                
                if let items = viewModel.raceItems {
                    
                    List(items) { item in
                        HStack(spacing: 16) {
                            Text(item.number)
                            Spacer()
                            Text(item.name)
                            Text(item.venu.country)
                        }
                    }
                    .listStyle(.inset)
                    .refreshable {
                        viewModel.loadNextRaces()
                    }
                } else {
                    LoadingView(
                        isLoading: viewModel.isLoading,
                        error: viewModel.loadingError
                    ) {
                        viewModel.loadNextRaces()
                    }
                }
            }
            .navigationBarTitle("Next to Go 🏇🏻 ")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadNextRaces()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NextToGoView()
    }
}
