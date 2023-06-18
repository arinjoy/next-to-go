//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DataLayer

// TODO: Update and finalise the UI

struct RacesListView: View {
    
    @ObservedObject private var viewModel: NextToGoViewModel
    
    init(viewModel: NextToGoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        if let items = viewModel.raceItems {
            List(items) { race in
                NavigationLink(destination: EmptyView()) {
                    RaceRowView(raceItem: .init(race: race))
               }
            }
            .listStyle(.inset)
            .refreshable {
                viewModel.loadNextRaces()
            }
        } else {
            EmptyView()
        }
    }
    
}
