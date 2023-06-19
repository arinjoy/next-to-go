//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import SwiftUI

struct CollectionLoadingView<Item, Content: View, EmptyView: View, ErrorView: View>: View {
    
    // MARK: - Properties

    private let state: CollectionLoadingState<[Item]>
    private let makeContent: ([Item]) -> Content
    private let makeEmpty: () -> EmptyView
    private let makeError: (Error) -> ErrorView
    
    private let fade = AnyTransition.opacity.animation(Animation.linear(duration: 0.5))
    
    // MARK: - Initializer
    
    init(
        loadingState: CollectionLoadingState<[Item]>,
        @ViewBuilder content: @escaping ([Item]) -> Content,
        @ViewBuilder empty: @escaping () -> EmptyView,
        @ViewBuilder error: @escaping (Error) -> ErrorView
    ) {
        state = loadingState
        makeContent = content
        makeEmpty = empty
        makeError = error
    }
    
    // MARK: - UI Body
    
    var body: some View {
        
        switch state {
        case let .loading(placeholders):
            makeContent(placeholders)
                .redacted(reason: .placeholder)
                .shimmer()
                .disabled(true)
                .transition(fade)
            
        case let .loaded(items):
            makeContent(items)
                .transition(fade)
            
        case .empty:
            makeEmpty()
                .transition(fade)
            
        case let .error(error):
            makeError(error)
                .transition(fade)
        }
    }
    
}
