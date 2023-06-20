//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import SwiftUI

struct ShimmerConfiguration {

    // MARK: - Properties

    let gradient: Gradient
    let initialLocation: (start: UnitPoint, end: UnitPoint)
    let finalLocation: (start: UnitPoint, end: UnitPoint)
    let duration: TimeInterval
    let opacity: Double

    static let `default` = ShimmerConfiguration(
        gradient: Gradient(stops: [
            .init(color: .black, location: 0),
            .init(color: .white, location: 0.3),
            .init(color: .white, location: 0.7),
            .init(color: .black, location: 1),
        ]),
        initialLocation: (start: UnitPoint(x: -1, y: 0.5), end: .leading),
        finalLocation: (start: .trailing, end: UnitPoint(x: 2, y: 0.5)),
        duration: 2,
        opacity: 0.6
    )
}

struct ShimmeringView<Content: View>: View {

    // MARK: - Properties

    private let content: () -> Content
    private let configuration: ShimmerConfiguration

    @State private var startPoint: UnitPoint
    @State private var endPoint: UnitPoint

    // MARK: - Initializer

    init(
        configuration: ShimmerConfiguration,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.configuration = configuration
        self.content = content
        _startPoint = .init(wrappedValue: configuration.initialLocation.start)
        _endPoint = .init(wrappedValue: configuration.initialLocation.end)
    }

    // MARK: - UI Body

    var body: some View {

        ZStack {

            content()

            LinearGradient(
                gradient: configuration.gradient,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .opacity(configuration.opacity)
            .blendMode(.screen)
            .onAppear {
                withAnimation(Animation.linear(duration: configuration.duration).repeatForever(autoreverses: false)) {
                    startPoint = configuration.finalLocation.start
                    endPoint = configuration.finalLocation.end
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ShimmerModifier: ViewModifier {

    let configuration: ShimmerConfiguration

    func body(content: Content) -> some View {
        ShimmeringView(configuration: configuration) { content }
    }
}

extension View {

    func shimmer(configuration: ShimmerConfiguration = .default) -> some View {
        modifier(ShimmerModifier(configuration: configuration))
    }

}
