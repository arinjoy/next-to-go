//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation

struct ApiConstants {
    
    static let baseURL = URL(string: "https://api.neds.com.au/rest/v1/racing/")!
    
}

public struct RacesListData: Decodable {
    let data: RacesListResponse
}

public struct RacesListResponse: Decodable {
    
    let results: Dictionary<String, RaceSummary>
    
    private enum CodingKeys: String, CodingKey {
        case results = "race_summaries"
    }
}

public struct RaceSummary: Decodable, Identifiable {
    
    public let id: String
    let categoryId: String
    let name: String
    let meetingName: String
    let advertisedStartTime: UInt32
    let venueCountry: String
}

extension RaceSummary {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.categoryId = try container.decode(String.self, forKey: .categoryId)
        self.name = try container.decode(String.self, forKey: .name)
        self.meetingName = try container.decode(String.self, forKey: .meetingName)
        self.venueCountry = try container.decode(String.self, forKey: .venueCountry)
        
        let advertisedStart = try container.nestedContainer(keyedBy: AdvertisedStartKeys.self, forKey: .advertisedStart)
        self.advertisedStartTime = try advertisedStart.decode(UInt32.self, forKey: .seconds)
    }
    
}


extension RaceSummary {

    private enum CodingKeys: String, CodingKey {
        case id = "race_id"
        case categoryId = "category_id"
        case name = "race_name"
        case meetingName = "meeting_name"
        case advertisedStart = "advertised_start"
        case venueCountry = "venue_country"
    }
    
    enum AdvertisedStartKeys: String, CodingKey {
        case seconds = "seconds"
    }
    
}

extension RaceSummary: Hashable {
    
    public static func == (lhs: RaceSummary, rhs: RaceSummary) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(categoryId)
        hasher.combine(name)
        hasher.combine(meetingName)
    }
    
}
