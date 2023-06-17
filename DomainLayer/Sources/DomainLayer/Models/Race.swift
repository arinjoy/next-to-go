//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation
import DataLayer

public struct Race: Identifiable {
    
    public let id: String
    public let category: Category
    public let name: String
    public let number: String
    public let meeting: String
    public let startTime: Date
    public let venu: Venu
    
    public init?(from summary: DataLayer.RaceSummary) {
        guard
            let category = Race.Category(rawValue: summary.categoryId)
        else {
            return nil
        }
              
        self.id = summary.id
        self.category = category
        
        self.number = "R\(summary.number)"
        
        // race-name can be missing/nil, so we fill the meeting-name
        // as backup value to render something on UI
        self.name = summary.name ?? summary.meeting ?? ""
        
        // meeting-name can be missing/nil, so we fill the race-name
        // as backup value to render something on UI
        self.meeting = summary.meeting ?? summary.name ?? ""
        
        self.startTime = Date(timeIntervalSince1970: TimeInterval(summary.advertisedStartTime))
        self.venu = .init(state: summary.venueState, country: summary.venueCountry)
    }
    
}

public extension Race {
    
    struct Venu {
        public let state: String
        public let country: String
    }
    
    enum Category: String {
        case horse =        "4a2788f8-e825-4d36-9894-efd4baf1cfae"
        case greyhound =    "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
        case harness =      "161d9be2-e909-4326-8c2c-35ed71fb460b"
        case all =          ""
        
        init(fromRawValue rawValue: String? = nil) {
            guard let rawValue else {
                self = .all
                return
            }
            self = Category(rawValue: rawValue) ?? .all
        }
    }
    
}

extension Race: Hashable {
    
    public static func == (lhs: Race, rhs: Race) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
        hasher.combine(name)
        hasher.combine(meeting)
    }
    
}

