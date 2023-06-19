import XCTest
@testable import DataLayer

final class RaceSummaryDecodingTests: XCTestCase {

    var testJSONData: Data!

    let jsonDecoder = JSONDecoder()

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests

    func testMappingSuccess() throws {

        // GIVEN - a valid JSON file with sample races list
        testJSONData = jsonData(forResource: "test_races_success")

        // WHEN - trying to decode the JSON into `RacesListResponse`
        let mappedItem = try? jsonDecoder.decode(RacesListResponse.self, from: testJSONData)

        // THEN - races list should be mapped from the data
        XCTAssertNotNil(mappedItem)

        let races = try XCTUnwrap(mappedItem?.races)

        // AND - there should be 5 races in the list
        XCTAssertEqual(races.count, 5)

        // AND - the race and all its content mapped correctly into the `RaceSummary` model
        let race = races[0]
        XCTAssertEqual(race.id, "21c38114-23ea-4418-8523-d1526288a824")
        XCTAssertEqual(race.name, "Red Snapper Seafoods, Christchurch C0")
        XCTAssertEqual(race.number, 2)
        XCTAssertEqual(race.meeting, "Manawatu")
        XCTAssertEqual(race.categoryId, "9daef0d7-bf3c-4f50-921d-8e818c60fe61")
        XCTAssertEqual(race.venueCountry, "NZ")
        XCTAssertEqual(race.venueState, "NZ")
        XCTAssertEqual(race.advertisedStartTime, 1687221000)
    }

    func testMappingFailure() throws {

        // GIVEN - a invalid races list JSON structure
        testJSONData = jsonData(forResource: "test_races_invalid_body")

        // WHEN - trying to decode the JSON into `RacesListResponse`
        let mappedItem = try? jsonDecoder.decode(RacesListResponse.self, from: testJSONData)

        // THEN - races list cannot be mapped
        XCTAssertNil(mappedItem)
    }
}

// MARK: - Test Helpers

private extension RaceSummaryDecodingTests {

    func jsonData(forResource resource: String) -> Data {
        let fileURLPath = Bundle.module.url(forResource: resource,
                                            withExtension: "json",
                                            subdirectory: "Mocks")

        // swiftlint:disable:next force_try force_unwrapping
        return try! Data(contentsOf: fileURLPath!)
    }

}
