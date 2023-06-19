//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct RacesListView: View {
    
    // MARK: - Properties
    
    let items: [Race]
    
    @Environment(\.redactionReasons) private var redactionReasons
      
    private var isRedacted: Bool { redactionReasons.contains(.placeholder) }
    
    // MARK: - UI Body
    
    var body: some View {
        
        List(items) { item in
            
            NavigationLink(
                
                // Dummy Destination detail page
                // TODO: Finish the detail page as your next feature
                // so that you can go there and bet...
                
                destination: MessageView(
                    message: "R\(item.number)" + item.meeting,
                    imageName: "figure.equestrian.sports"
                )
            ) {
                RaceRowView(raceItem: .init(race: item))
            }
        }
        .listStyle(.inset)
    }
}
