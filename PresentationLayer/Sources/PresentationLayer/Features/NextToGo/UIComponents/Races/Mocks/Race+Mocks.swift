//
//  File.swift
//  
//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import Foundation
import DomainLayer

public struct RaceMocks {

    static func race(withStartTime time: Date) -> Race {
        Race(
            id: "12345",
            category: .greyhound,
            name: "NY hounds on Fire",
            number: "5",
            meeting: "The fast and furious",
            startTime: time,
            venu: .init(state: "NY", country: "USA")
        )
    }

    static let raceOne = Race(
        id: "111",
        category: .horse,
        name: "Premio Jockey Club De Minas Fun Horse racing carnival",
        number: "2",
        meeting: "Gavea",
        startTime: Date.init(timeIntervalSinceNow: 1 * 60),
        venu: .init(state: "BRA", country: "BRA")
    )

    static let raceTwo = Race(
        id: "222",
        category: .greyhound,
        name: "Sportsbet Green Ticks (275+Rank)",
        number: "1",
        meeting: "Warragul Race",
        startTime: Date.init(timeIntervalSinceNow: 2.5 * 60),
        venu: .init(state: "VIC", country: "AUS")
    )

    static let raceThree = Race(
        id: "333",
        category: .harness,
        name: "The Mermaid Stakes(G3)",
        number: "5",
        meeting: "Hanshin",
        startTime: Date.init(timeIntervalSinceNow: 8 * 60),
        venu: .init(state: "JPN", country: "JPN")
    )

}
