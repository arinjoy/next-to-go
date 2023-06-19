//
//  Created by Arinjoy Biswas on 19/6/2023.
//

import SwiftUI
import SharedUtils
import DataLayer

struct ErrorMessageView: View {

    // MARK: - Properties
    
    let iconName: String
    let title: String
    let message: String
    
    @State private var isAnimatingIcon: Bool = false
    
    // MARK: - UI Body
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            
            Spacer()
            
            Image(systemName: iconName)
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .scaledToFit()
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
                .accessibilityHidden(true)
                .scaleEffect(isAnimatingIcon ? 1.05 : 0.98)
                .rotationEffect(isAnimatingIcon ? .degrees(0) : .degrees(15))
                .opacity(isAnimatingIcon ? 1.0 : 0.7)
                .animation(
                    .spring(response: 1, dampingFraction: 0.2, blendDuration: 0.0)
                    .repeatForever(autoreverses: false),
                    value: isAnimatingIcon
                )
                .padding(.bottom, 6)
                .onAppear() {
                    withAnimation {
                        isAnimatingIcon = true
                    }
                }
            
            Text(title)
                .font(.title3)
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .accessibilityAddTraits(.isStaticText)
            
            Spacer()
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .adaptiveScaleFactor()
        .padding()
    }
}


#if DEBUG
struct ErrorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessageView(
            iconName: "cloud.sun.bolt",
            title: "Oops, something isn't right!",
            message: "Please try again later"
        )
    }
}
#endif
