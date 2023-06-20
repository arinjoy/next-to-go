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

    func testCallLoad() throws {

        // given
        let networkServiceSpy = NetworkServiceSpy()

        // when
        _ = networkServiceSpy
            .load(Resource<RacesListResponse>.nextRaces(numberOfRaces: 5))

        // then

        // Spied call
        XCTAssertTrue(networkServiceSpy.loadReSourceCalled)

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

}
