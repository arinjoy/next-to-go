//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import SwiftUI
import SharedUtils

/// 🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽
//  FIXME: ‼️ Move all the copy / content... ‼️
/// used here via ViewModel / PresentationItem based bindings.
/// This is just a prototyping experimental feature screen for now.
/// Hard coded content here but UI and accessibility - font scaling &
/// VoiceOver all works nicely. To be finalised ...
///  🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽🤚🏽

// swiftlint:disable all
struct SettingsView: View {

    // MARK: - Properties

    @State private var isAnimatingIcon: Bool = false

    @Environment(\.dismiss) private var dismiss

    @AppStorage("isDarkMode") private var isDarkMode = false

    // MARK: - UI body

    // NOTE: Break down the sub section via `@ViewBuilder` based
    // child elements, show that easy to follow declarative code.
    // Otherwise, it looks like pyramid of doom with too many
    // nested blocks

    var body: some View {

        NavigationView {

            ScrollView(.vertical, showsIndicators: false) {

                VStack(spacing: 20) {

                    // MARK: - Section 1

                    GroupBox(
                        label: SettingsLabelView(text: "Next to Go", imageName: "info.circle")
                    ) {

                        Divider()
                            .padding(.vertical, 4)

                        HStack(alignment: .center, spacing: 16) {

                            Group {
                                if let appIconImage = UIImage(named: "AppIcon") {
                                    Image(uiImage: appIconImage)
                                        .resizable()
                                } else {
                                    Image(systemName: "figure.equestrian.sports")
                                        .resizable()
                                }
                            }
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .accessibilityHidden(true)
                            .scaleEffect(isAnimatingIcon ? 1.15 : 0.7)
                            .onAppear {
                                withAnimation(
                                    .easeOut(duration: 1.5)
                                    .repeatCount(2, autoreverses: false)
                                ) {
                                    isAnimatingIcon = true
                                }
                            }

                            // swiftlint:disable:next line_length
                            Text("Immerse yourself in the new world of personalised betting on races. Horse, Greyhound or Harness, whatever racing you're looking for internationally. Just filter them out an see the next most up to date 5 races to punt on.")
                                .font(.footnote)
                        }
                        .accessibilityElement(children: .combine)
                    }

                    // MARK: - Section 2

                    GroupBox(
                        label: SettingsLabelView(text: "Customization", imageName: "paintbrush")
                    ) {

                        Divider()
                            .padding(.vertical, 4)

                        Text(
                            "If you wish, you can update the theme to be dark mode. Also you can update larger accessibility font sizes from system settings and see how the app adapts to it."
                        )
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)

                        Toggle(isOn: $isDarkMode) {
                            Text("Dark Mode")
                        }
                        .padding()
                        .background(
                          Color(UIColor.tertiarySystemBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )
                    }

                    // MARK: - Section 3

                    GroupBox(
                        label: SettingsLabelView(
                            text: "Creator",
                            imageName: "person.crop.square.filled.and.at.rectangle"
                        )
                    ) {
                        SettingsRowView(name: "Developer", value: "Arinjoy Biswas")

                        SettingsRowView(name: "Designer", value: "🧑🏽‍🎨 Arinjoy")

                        SettingsRowView(
                            name: "Github",
                            linkLabel: "github.com/arinjoy",
                            linkURL: URL(string: "https://github.com/arinjoy")!
                        )

                        SettingsRowView(
                            name: "LinkedIn",
                            linkLabel: "linkedin.com/arinjoy",
                            linkURL: URL(string: "https://www.linkedin.com/in/arinjoybiswas/")!
                        )
                    }

                    // MARK: - Section 4

                    GroupBox(
                        label: SettingsLabelView(text: "Application", imageName: "apps.iphone")
                    ) {
                        SettingsRowView(name: "Compatibility", value: "iOS 15+")
                        SettingsRowView(name: "SwiftUI", value: "v3")
                        SettingsRowView(name: "App", value: "1.2.1")
                    }

                    GroupBox(
                        label: SettingsLabelView(
                            text: "Courtesy",
                            imageName: "heart.text.square"
                        )
                    ) {
                        SettingsRowView(
                            name: "SwiftUI Animations",
                            linkLabel: "kodeco.com",
                            linkURL: URL(string: "https://www.kodeco.com/books/ios-animations-by-tutorials/v6.0/chapters/1-introduction-to-animations-with-swiftui")!
                        )

                        SettingsRowView(
                            name: "Shimmers",
                            linkLabel: "joshhomann.medium",
                            linkURL: URL(string: "https://joshhomann.medium.com/generic-shimmer-loading-skeletons-in-swiftui-26fcd93ccee5")!
                        )

                        SettingsRowView(
                            name: "Custom SF Symbols",
                            linkLabel: "medium.com",
                            linkURL: URL(string: "https://medium.com/@mkproduct-stories/how-to-create-sf-symbols-with-sketch-2952ee02abf5")!
                        )


                    }
                }
                .navigationBarTitle(Text("Settings"), displayMode: .large)
                .navigationBarItems(
                    trailing:
                        Button(
                            action: {
                                let haptic = UIImpactFeedbackGenerator(style: .medium)
                                haptic.impactOccurred()
                                dismiss()
                            },
                            label: {
                                Image(systemName: "multiply.circle.fill")
                                    .resizable()
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(uiColor: UIColor.lightGray))
                                    .accessibilityLabel("Close")
                            }
                        )
                )
                .padding()
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
// swiftlint:disable all

struct SettingsLabelView: View {

    let text: String
    let imageName: String

    var body: some View {
        HStack {
            Text(text.uppercased())
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)

            Spacer()

            Image(systemName: imageName)
                .accessibilityHidden(true)
        }
        .adaptiveScaleFactor()
        .accessibilityElement(children: .combine)
    }
}

struct SettingsRowView: View {

    var name: String
    var value: String?
    var linkLabel: String?
    var linkURL: URL?

    // MARK: - UI Body

    var body: some View {

        VStack {

              Divider().padding(.vertical, 4)

              HStack {

                Text(name)
                      .foregroundColor(Color.gray)

                Spacer()

                if let value {

                    Text(value)

                } else if let linkLabel, let linkURL {

                    Link(linkLabel, destination: linkURL)
                        .font(.callout)
                        .foregroundColor(.blue)

                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.blue)
                        .accessibilityHidden(true)

                } else {
                    EmptyView()
                }
            }
              .adaptiveScaleFactor()
              .accessibilityElement(children: .combine)
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
          .previewDevice("iPhone 13")
    }
}
#endif
