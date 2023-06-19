//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import PresentationLayer

@main
struct NextToGoApp: App {

    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {

        WindowGroup {

            NextToGoView()
                .tint(.red) // Global App Tint (accent colour)
                .preferredColorScheme(isDarkMode ? .dark : .light) // link dark / light mode scheme
        }
    }
}
