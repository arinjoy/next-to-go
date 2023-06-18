//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct RaceRowView: View {
    
    @ObservedObject private var presentationItem: RacePresentationItem
    
    @State private var isAnimatingImage: Bool = false
    
    init(presentationItem: RacePresentationItem) {
        self.presentationItem = presentationItem
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            
            /**
             https://medium.com/@amosgyamfi/learning-swiftui-spring-animations-the-basics-and-beyond-4fb032212487
             */
            
            Image(systemName: presentationItem.iconName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
                .accessibilityHidden(true)
                .scaleEffect(isAnimatingImage ? 1.05 : 0.95)
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
                    Text(presentationItem.race.number)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                    
                    Text(presentationItem.race.meeting)
                        .font(.title3)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .foregroundColor(Color.primary)
                     
                    Spacer()
                    
                    Text(presentationItem.timeString ?? "")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(Color.red)
                }

                HStack(spacing: 16) {
                    Text(presentationItem.race.venu.country)
                    Text(presentationItem.race.name)
         
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
    
    static let presentationItem = RacePresentationItem(race: race)
    
    static var previews: some View {
        RaceRowView(presentationItem: presentationItem)
            .previewLayout(.sizeThatFits)
            .padding()
  }
}
#endif


