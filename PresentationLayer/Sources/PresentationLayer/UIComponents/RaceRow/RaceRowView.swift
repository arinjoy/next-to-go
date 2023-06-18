//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer
import SharedUtils

struct RaceRowView: View {
    
    // MARK: - Properties
    
    @ObservedObject private var raceItem: RacePresentationItem
    
    @State private var isAnimatingIcon: Bool = false
    @State private var isAnimatingFlag: Bool = false
    
    @Environment(\.sizeCategory) private var sizeCategory
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // MARK: - Initializer
    
    init(raceItem: RacePresentationItem) {
        self.raceItem = raceItem
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
                        
            animatedIcon
            
            VStack(alignment: .leading, spacing: 4) {
                
                infoTextStack
                
                descriptionStack
            }
            .padding(.trailing, 8)
            
        }
        .adaptiveScaleFactor()
        .accessibilityElement(children: .combine)
        .onAppear() {
            withAnimation(.linear(duration: 2).repeatForever()) {
                isAnimatingIcon = true
            }
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                isAnimatingFlag = true
            }
        }
    }
}

private extension RaceRowView {
    
    @ViewBuilder
    var animatedIcon: some View {
        
        /** Animation related code courtesy to this amazing tutorial: 🙏🏽
         https://medium.com/@amosgyamfi/learning-swiftui-spring-animations-the-basics-and-beyond-4fb032212487
         */
        
        Image(raceItem.iconName, bundle: .module)
            .font(.largeTitle)
            .fontWeight(.bold) // For some reason bold effect isn't working well 😿
            .foregroundColor(.primary)
            .accessibilityHidden(true)
            .scaleEffect(isAnimatingIcon ? 1.15 : 0.9)
            .offset(y: isAnimatingIcon ? -7 : 0)
            .offset(x: isAnimatingIcon ? 5 : 0)
            .animation(
                .spring(response: 1.0, dampingFraction: 0.0, blendDuration: 0.1)
                .repeatForever(autoreverses: true),
                value: isAnimatingIcon
            )
            .animation(
                .interpolatingSpring(mass: 2, stiffness: 170, damping: 10, initialVelocity: 0)
                .repeatForever(autoreverses: true),
                value: isAnimatingIcon
            )
            .padding(.trailing, 6)
    }
    
    @ViewBuilder
    var infoTextStack: some View {
        
        // 🤚🏽 Only flip layout when system detects large font size
        // and horizontal compact layout, else gets normal desired layout
        
        if sizeCategory >= .extraExtraExtraLarge,
           horizontalSizeClass == .compact {
            VStack(alignment: .leading, spacing: 8) {
                raceName
                HStack {
                    raceNumber
                    Spacer()
                    raceTimeCountdown
                }
            }
        } else {
            HStack(spacing: 8) {
                raceName
                raceNumber
                Spacer()
                raceTimeCountdown
            }
        }
    }
    
    @ViewBuilder
    var raceName: some View {
        Text(raceItem.name)
            .font(.title3)
            .fontWeight(.medium)
            .lineLimit(1)
            .foregroundColor(.primary)
    }
    
    @ViewBuilder
    var raceNumber: some View {
        Text(raceItem.number)
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }
    
    @ViewBuilder
    var raceTimeCountdown: some View {
        Text(raceItem.timeString ?? "")
            .font(.callout)
            .fontWeight(.regular)
            .foregroundColor(.red)
    }
    
    @ViewBuilder
    var descriptionStack: some View {
        HStack {
            countryFlag
            description
        }
    }
    
    @ViewBuilder
    var countryFlag: some View {
        if let countryEmoji = raceItem.countryEmoji {
            Text(countryEmoji)
                .font(.title)
                .transition(.opacity)
                .scaleEffect(isAnimatingFlag ? 1.02 : 0.98)
                .opacity(isAnimatingFlag ? 1.0 : 0.65)
                .animation(
                    .spring(response: 1.0, dampingFraction: 0.0, blendDuration: 0.1)
                    .repeatForever(autoreverses: true),
                    value: isAnimatingFlag
                )
                .animation(
                    .interpolatingSpring(mass: 2, stiffness: 170, damping: 10, initialVelocity: 0)
                    .repeatForever(autoreverses: true),
                    value: isAnimatingFlag
                )
        } else {
            EmptyView()
        }
    }
        
    @ViewBuilder
    var description: some View {
        Text(raceItem.description)
            .font(.subheadline)
            .fontWeight(.medium)
            .lineLimit(2)
            .foregroundColor(.secondary)
    }
}

#if DEBUG
struct RaceRowView_Previews: PreviewProvider {

    static let race1 = Race(
        id: "111",
        category: .horse,
        name: "Premio Jockey Club De Minas Fun Horse racing carnival",
        number: "R2",
        meeting: "Gavea",
        startTime: Date.init(timeIntervalSinceNow: 3 * 60),
        venu: .init(state: "BRA", country: "BRA")
    )
    
    static let race2 = Race(
        id: "222",
        category: .greyhound,
        name: "Sportsbet Green Ticks (275+Rank)",
        number: "R1",
        meeting: "Warragul",
        startTime: Date.init(timeIntervalSinceNow: 2 * 60),
        venu: .init(state: "VIC", country: "AUS")
    )
    
    static let race3 = Race(
        id: "333",
        category: .harness,
        name: "The Mermaid Stakes(G3)",
        number: "R5",
        meeting: "Hanshin",
        startTime: Date.init(timeIntervalSinceNow: 1 * 60),
        venu: .init(state: "JPN", country: "JPN")
    )
    
    static let items: [RacePresentationItem] = [
        race1,
        race2,
        race3,
    ]
        .map { RacePresentationItem(race: $0) }
    
    static var previews: some View {
        VStack(spacing: 20) {
            RaceRowView(raceItem: items[0])
            RaceRowView(raceItem: items[1])
            RaceRowView(raceItem: items[2])
            Spacer()
        }
        .padding(.all, 20)
  }
}
#endif


