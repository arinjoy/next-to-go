//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import SharedUtils
import DomainLayer

struct RacesListView: View {
    
    // MARK: - Properties
    
    let items: [Race]
    
    @Environment(\.redactionReasons) private var redactionReasons
      
    private var isRedacted: Bool { redactionReasons.contains(.placeholder) }
    
    // MARK: - UI Body
    
    var body: some View {
        
        List(items) { item in
            
            let presentationItem = RacePresentationItem(race: item)
            
            NavigationLink(destination: RaceDetailsView(item: presentationItem)) {
                RaceRowView(raceItem: .init(race: item))
            }
            
        }
        .listStyle(.inset)
    }
}

// TODO: Finish the detail page as your next feature
// Destination detail page so that you can go there and
// be as much creative as possible to give the punters the edge. 😁

// WIP: Finish the Race details view here...

struct RaceDetailsView: View {
    
    let item: RacePresentationItem
    
    var body: some View {
     
        VStack(alignment: .center, spacing: 16) {
            
            Image(item.iconName, bundle: .module)
                .resizable()
                .scaledToFit()
                .font(.largeTitle)
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
                .accessibilityHidden(true)
            
            Text(item.name)
                .font(.title)
                .foregroundColor(.primary)
            
            Text(item.raceNumber)
                .font(.title)
                .foregroundColor(.primary)
            
            Text(item.countryEmoji ?? "")
                .font(.largeTitle)
            
            Text(item.description)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(item.countDownTimeText ?? "")
                .font(.body)
                .foregroundColor(.red)
            
            Spacer()
        }
        .padding()
        .adaptiveScaleFactor()
    }
    
}
