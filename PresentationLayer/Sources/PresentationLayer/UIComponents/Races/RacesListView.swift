//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI

struct RacesListView: View {
    
    // MARK: - Properties
    
    @ObservedObject private var viewModel: NextToGoViewModel
    
    // MARK: - Initializer
    
    init(viewModel: NextToGoViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI Body
    
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
