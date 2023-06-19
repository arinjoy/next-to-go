//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI

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
        } else {
            EmptyView()
        }
    }
    
}
