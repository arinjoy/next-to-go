//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer

struct RaceRowView: View {
    
    var race: Race
    
    @State private var isAnimatingImage: Bool = false
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            
            /**
             https://medium.com/@amosgyamfi/learning-swiftui-spring-animations-the-basics-and-beyond-4fb032212487
             */
            
            Image(systemName: "tortoise")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20, alignment: .center)
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
                    Text(race.number)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                    
                    Text(race.meeting)
                      .font(.title3)
                      .foregroundColor(Color.primary)
                }

                Text(race.name)
                  .font(.caption)
                  .multilineTextAlignment(.trailing)
                  .foregroundColor(Color.secondary)
            }
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
        name: "Race2 - Premio Jockey Club De Minas Gerais",
        number: "R2",
        meeting: "Gavea",
        startTime: Date.init(timeIntervalSinceNow: 2 * 60 * 60),
        venu: .init(state: "BRA", country: "BRA")
    )
    
    static var previews: some View {
        RaceRowView(race: race)
            .previewLayout(.sizeThatFits)
            .padding()
  }
}
#endif


