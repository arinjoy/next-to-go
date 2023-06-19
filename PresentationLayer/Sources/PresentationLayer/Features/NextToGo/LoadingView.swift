//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import DataLayer

// TODO: Update and finalise the UI
// Bind to its viewModel and abstract copies etc.

struct LoadingView: View {
    
    let isLoading: Bool
    let error: NetworkError?
    let retryAction: (() -> ())?
    
    var body: some View {
            GeometryReader { geo in
                
                VStack {
                    
                    Spacer().frame(height: geo.size.height / 3)
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                    } else if error != nil {
                        
                        HStack {
                            
                            Spacer()
                            
                            VStack(spacing: 16) {
                                
                                // TODO: Use custom error message mapped from the error code
                                Text(LocalizedStringKey("next.togo.races.error.heading"))
                                    .font(.headline)
                                
                                if let retryAction {
                                    Button(action: retryAction) {
                                        Text(LocalizedStringKey("next.togo.races.error.retry.button.title"))
                                    }
                                    .foregroundColor(Color.blue)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            Spacer()
                        }
                    } else {
                        EmptyView()
                    }
                }
                
            }
    }
}
