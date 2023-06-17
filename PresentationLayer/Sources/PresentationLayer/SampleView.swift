//
//  SampleView.swift
//  NextToGo
//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import SwiftUI
import DataLayer
import DomainLayer
import SharedUtils
import Combine

public struct SampleView: View {
    
    var cancellables = Set<AnyCancellable>()
    
    public init() {
        
        let interactor = NextRacesInteractor()
        
        interactor
            .nextFiveRaces(for: .horse)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { moviesResponse in
                print(moviesResponse)
            }
            .store(in: &cancellables)
        
    }
    
    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
