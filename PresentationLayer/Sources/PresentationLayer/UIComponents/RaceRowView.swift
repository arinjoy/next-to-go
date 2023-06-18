//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct RaceRowView: View {
    
    @ObservedObject private var raceItem: RacePresentationItem
    
    @State private var isAnimatingImage: Bool = false
    
    init(raceItem: RacePresentationItem) {
        self.raceItem = raceItem
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            
            /**
             https://medium.com/@amosgyamfi/learning-swiftui-spring-animations-the-basics-and-beyond-4fb032212487
             */
            
            Image(raceItem.iconName, bundle: .module)
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.red)
                .frame(width: 25, height: 25, alignment: .center)
                .accessibilityHidden(true)
                .scaleEffect(isAnimatingImage ? 1.1 : 0.95)
                .offset(y: isAnimatingImage ? -5 : 0)
                .animation(
                    .spring(response: 1.0, dampingFraction: 0.0, blendDuration: 0.1)
                    .repeatForever(autoreverses: true),
                    value: isAnimatingImage
                )
                .animation(
                    .interpolatingSpring(mass: 2, stiffness: 170, damping: 10, initialVelocity: 0)
                    .repeatForever(autoreverses: true),
                    value: isAnimatingImage
                )

            VStack(alignment: .leading, spacing: 4) {

                HStack(spacing: 16) {
                    
                    Text(raceItem.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(Color.primary)
                    
                    Text(raceItem.number)
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(Color.primary)
                    
                     
                    Spacer()
                    
                    Text(raceItem.timeString ?? "")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(Color.red)
                }

                HStack(spacing: 16) {
//                    Text(raceItem.venu.country)
                    Text(raceItem.description)
         
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundColor(Color.secondary)
                

            }
            .accessibilityElement(children: .combine)
        }
        .onAppear() {
            withAnimation(.linear(duration: 2).repeatForever()) {
                isAnimatingImage = true
            }
        }
    }
}

#if DEBUG
struct RaceRowView_Previews: PreviewProvider {

    static let race = Race(
        id: "111",
        category: .horse,
        name: "Premio Jockey Club De Minas",
        number: "R2",
        meeting: "Gavea",
        startTime: Date.init(timeIntervalSinceNow: 3 * 60),
        venu: .init(state: "BRA", country: "BRA")
    )
    
    static let item = RacePresentationItem(race: race)
    
    static var previews: some View {
        RaceRowView(raceItem: item)
            .previewLayout(.sizeThatFits)
            .padding()
  }
}
#endif


