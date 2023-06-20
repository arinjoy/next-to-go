//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import Foundation

// swiftlint:disable force_try force_unwrapping
public struct TestHelper {

    public static var sampleRacesList: RacesListResponse {
        return try! JSONDecoder().decode(
            RacesListResponse.self,
            from: TestHelper.jsonData(forResource: "test_races_success")
        )
    }

    public static func jsonData(forResource resource: String) -> Data {
        let fileURLPath = Bundle.module.url(forResource: resource,
                                            withExtension: "json",
                                            subdirectory: "JSON/Mocks")

        return try! Data(contentsOf: fileURLPath!)
    }
}
// swiftlint:enable force_try force_unwrapping
