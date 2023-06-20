//
//  File.swift
//  
//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import Foundation
@testable import DataLayer

// swiftlint:disable force_try force_unwrapping
struct TestHelper {

    static var sampleRacesList: RacesListResponse {
        return try! JSONDecoder().decode(
            RacesListResponse.self,
            from: TestHelper.jsonData(forResource: "test_races_success")
        )
    }

    static func jsonData(forResource resource: String) -> Data {
        let fileURLPath = Bundle.module.url(forResource: resource,
                                            withExtension: "json",
                                            subdirectory: "Mocks")

        return try! Data(contentsOf: fileURLPath!)
    }
}
// swiftlint:enable force_try force_unwrapping
