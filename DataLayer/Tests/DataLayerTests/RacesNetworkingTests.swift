//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import XCTest
import Combine
@testable import DataLayer

final class RacesNetworkingTests: XCTestCase {

    var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        super.tearDown()
    }

    // MARK: - Tests

    func testSpyLoadingResource() throws {

        // GIVEN - network service that is a spy
        let networkServiceSpy = NetworkServiceSpy()

        // WHEN - loading of desired resource type
        _ = networkServiceSpy
            .load(Resource<RacesListResponse>.nextRaces(numberOfRaces: 5))

        // THEN - Spying works correctly to see what values are being hit

        // Spied call
        XCTAssertTrue(networkServiceSpy.loadResourceCalled)

        // Spied values
        XCTAssertNotNil(networkServiceSpy.url)
        XCTAssertEqual(
            networkServiceSpy.url?.absoluteString,
            "https://api.neds.com.au/rest/v1/racing/"
        )

        XCTAssertNotNil(networkServiceSpy.parameters)
        XCTAssertEqual(networkServiceSpy.parameters?.count, 2)

        XCTAssertEqual(networkServiceSpy.parameters?.first?.0, "method")
        XCTAssertEqual(networkServiceSpy.parameters?.first?.1.description, "nextraces")

        XCTAssertEqual(networkServiceSpy.parameters?.last?.0, "count")
        XCTAssertEqual(networkServiceSpy.parameters?.last?.1.description, "5")

        XCTAssertNotNil(networkServiceSpy.request)
    }

    func testSuccessfulLoading() throws {
        var receivedError: NetworkError?
        var receivedResponse: RacesListResponse?

        // GIVEN - network service that is a Mock with sample list successfully without error
        let networkServiceMock = NetworkServiceMock(response: TestHelper.sampleRacesList, returningError: false)

        // WHEN - loading of desired resource type
        networkServiceMock
            .load(Resource<RacesListResponse>.nextRaces(numberOfRaces: 5))
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received race response should be correct
        XCTAssertNotNil(receivedResponse)
        XCTAssertEqual(receivedResponse?.races.count, 5)
        XCTAssertEqual(receivedResponse?.races.first?.name, "Red Snapper Seafoods, Christchurch C0")
        XCTAssertEqual(receivedResponse?.races.first?.number, 2)
        XCTAssertEqual(receivedResponse?.races.first?.meeting, "Manawatu")

        // Note: The rest of the JSON mapping related tests are always done
        // at the unit level inside`RaceSummaryDecodingTests`.
        // So not repeating for each property...

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

    func testFailureLoading() throws {
        var receivedError: NetworkError?
        var receivedResponse: RacesListResponse?

        // GIVEN - network service that to return an `serviceUnavailable` error
        let networkServiceMock = NetworkServiceMock(
            response: TestHelper.sampleRacesList,
            returningError: true,
            error: .serviceUnavailable
        )

        // WHEN - loading of desired resource type
        networkServiceMock
            .load(Resource<RacesListResponse>.nextRaces(numberOfRaces: 5))
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - there should be an error returned
        XCTAssertNotNil(receivedError)

        // AND - error is correct as type
        XCTAssertEqual(receivedError, .serviceUnavailable)

        // AND - race response should not be returned
        XCTAssertNil(receivedResponse)
    }

}
