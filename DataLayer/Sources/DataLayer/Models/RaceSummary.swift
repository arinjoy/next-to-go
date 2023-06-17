//
//  Created by Arinjoy Biswas on 17/6/2023.
//

import Foundation

struct ApiConstants {
    static let baseURL = URL(string: "https://api.neds.com.au/rest/v1/racing/")!
}

public struct RacesListResponse: Decodable {
    
    public let races: [RaceSummary]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedData = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let dictArray = try nestedData.decode(Dictionary<String, RaceSummary>.self, forKey: CodingKeys.raceSummaries)
        self.races = dictArray.map { $1 }
            .sorted { $0.advertisedStartTime > $1.advertisedStartTime }
    }
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case raceSummaries = "race_summaries"
    }
    
}

public struct RaceSummary: Decodable, Identifiable {
    public let id: String
    public let categoryId: String
    public let name: String
    public let number: Int
    public let meetingName: String
    public let advertisedStartTime: UInt32
    public let venueState: String
    public let venueCountry: String
}

extension RaceSummary {

    private enum CodingKeys: String, CodingKey {
        case id = "race_id"
        case categoryId = "category_id"
        case name = "race_name"
        case number = "race_number"
        case meetingName = "meeting_name"
        case advertisedStart = "advertised_start"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
    
    enum AdvertisedStartKeys: String, CodingKey {
        case seconds = "seconds"
    }
    
}

extension RaceSummary {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.categoryId = try container.decode(String.self, forKey: .categoryId)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decode(Int.self, forKey: .number)
        self.meetingName = try container.decode(String.self, forKey: .meetingName)
        self.venueState = try container.decode(String.self, forKey: .venueState)
        self.venueCountry = try container.decode(String.self, forKey: .venueCountry)
        
        let advertisedStart = try container.nestedContainer(keyedBy: AdvertisedStartKeys.self, forKey: .advertisedStart)
        self.advertisedStartTime = try advertisedStart.decode(UInt32.self, forKey: .seconds)
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
