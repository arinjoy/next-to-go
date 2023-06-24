//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import SwiftUI
import DomainLayer
import SharedUtils

struct RaceItemView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: RaceItemViewModel

    @State private var isAnimatingIcon: Bool = false
    @State private var isAnimatingFlag: Bool = false
    @State private var isAnimatingCountdown: Bool = false

    @Environment(\.sizeCategory) private var sizeCategory

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    // MARK: - Initializer

    init(viewModel: RaceItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .center, spacing: 16) {

            animatedIcon

            VStack(alignment: .leading, spacing: 4) {

                infoTextStack

                descriptionStack
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    isAnimatingFlag = true
                }
            }

            .padding(.trailing, 8)
        }
        .adaptiveScaleFactor()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewModel.combinedAccessibilityLabel)
    }
}

private extension RaceItemView {

    @ViewBuilder
    var animatedIcon: some View {

        /** Animation related code courtesy to this amazing tutorial: 🙏🏽
         https://medium.com/@amosgyamfi/learning-swiftui-spring-animations-the-basics-and-beyond-4fb032212487
         */

        Image(viewModel.iconName, bundle: .module)
            .font(.largeTitle)
            .foregroundColor(.red)
            .accessibilityHidden(true)
            .scaleEffect(isAnimatingIcon ? 1.15 : 0.9)
            .offset(y: isAnimatingIcon ? -6 : 0)
            .offset(x: isAnimatingIcon ? 4 : 0)
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
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever()) {
                    isAnimatingIcon = true
                    isAnimatingCountdown = viewModel.highlightCountdown
                }
            }
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
            HStack {
                HStack {
                    raceName
                    raceNumber
                }
                Spacer(minLength: 20)
                raceTimeCountdown
            }
        }
    }

    @ViewBuilder
    var raceName: some View {
        Text(viewModel.name)
            .font(.title3)
            .fontWeight(.medium)
            .lineLimit(1)
            .foregroundColor(.primary)
    }

    @ViewBuilder
    var raceNumber: some View {
        Text(viewModel.raceNumber)
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }

    @ViewBuilder
    var raceTimeCountdown: some View {
        Text(viewModel.countdownText ?? "")
            .font(.callout)
            .fontWeight(.regular)
            .foregroundColor(
                viewModel.highlightCountdown ? .red : .primary
            )
            .opacity(isAnimatingCountdown ? 1.0 : 0.7)
            .scaleEffect(
                isAnimatingCountdown ? 1.03 : 0.98
            )
            .animation(
                .spring(response: 0.5).repeatForever(autoreverses: true),
                value: isAnimatingCountdown
            )
            .onAppear {
                withAnimation {
                    isAnimatingCountdown = true && viewModel.highlightCountdown
                }
            }
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
        if let countryEmoji = viewModel.countryEmoji {
            Text(countryEmoji)
                .font(.title)
                .scaleEffect(isAnimatingFlag ? 1.04 : 0.99)
                .opacity(isAnimatingFlag ? 1.0 : 0.5)
                .animation(
                    .spring(response: 1.0, dampingFraction: 0.0, blendDuration: 0.1)
                    .repeatForever(autoreverses: true),
                    value: isAnimatingFlag
                )
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var description: some View {
        Text(viewModel.description)
            .font(.subheadline)
            .fontWeight(.medium)
            .lineLimit(2)
            .foregroundColor(.secondary)
    }
}

#if DEBUG
struct RaceRowView_Previews: PreviewProvider {

    static let items: [RaceItemViewModel] = [
        RaceMocks.raceOne,
        RaceMocks.raceTwo,
        RaceMocks.raceThree,
    ]
        .map { RaceItemViewModel(race: $0) }

    static var previews: some View {
        VStack(spacing: 20) {
            RaceItemView(viewModel: items[0])
            RaceItemView(viewModel: items[1])
            RaceItemView(viewModel: items[2])
            Spacer()
        }
        .padding(.all, 20)
  }
}
#endif
