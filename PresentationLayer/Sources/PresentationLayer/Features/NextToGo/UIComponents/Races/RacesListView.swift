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

            let itemViewModel = RaceItemViewModel(race: item)

            NavigationLink(destination: RaceDetailsView(viewModel: itemViewModel)) {
                RaceItemView(viewModel: .init(race: item))
            }

        }
        .listStyle(.inset)
    }
}

// TODO: 🤚🏽 Finish the detail page as your next feature 🤚🏽
// Destination detail page so that you can go there and
// be as much creative as possible to give the punters the edge. 😁

// WIP: Finish the Race details view here...

struct RaceDetailsView: View {

    let viewModel: RaceItemViewModel

    var body: some View {

        VStack(alignment: .center, spacing: 16) {

            Image(viewModel.iconName, bundle: .module)
                .resizable()
                .scaledToFit()
                .font(.largeTitle)
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
                .accessibilityHidden(true)

            Text(viewModel.name)
                .font(.title)
                .foregroundColor(.primary)

            Text(viewModel.raceNumber)
                .font(.title)
                .foregroundColor(.primary)

            Text(viewModel.countryEmoji ?? "")
                .font(.largeTitle)

            Text(viewModel.description)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text(viewModel.countdownText ?? "")
                .font(.body)
                .foregroundColor(.red)

            Spacer()
        }
        .padding()
    }

}
