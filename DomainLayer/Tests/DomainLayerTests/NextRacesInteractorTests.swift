import XCTest
import Combine
@testable import DataLayer
@testable import DomainLayer

// swiftlint:disable force_unwrapping
final class NextRacesInteractorTests: XCTestCase {

    private var interactor: NextRacesInteracting!

    private var cancellables: [AnyCancellable] = []

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        // Dependency injection to have the stubbed provider
        // that returns sample response as stubbed way from
        // DataLayer's service implementation

        interactor = NextRacesInteractor(
            networkService: ServicesProvider.localStubbedProvider().network
        )
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        interactor = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testCallingServiceSpy() throws {

        // NOTE:
        // Integration level testing from `Interactor` -> `NetworkService`

        // GIVEN - network service that is a spy
        let serviceSpy = NetworkServiceSpy()
        interactor = NextRacesInteractor(networkService: serviceSpy)

        // WHEN - being requested to load races
        interactor.nextRaces(
            forCategories: [.horse, .greyhound, .harness],
            andCountry: nil,
            numberOfRaces: 20,
            hardNegativeTolerance: nil
        )
        .sink { _ in } receiveValue: { _ in
        }.store(in: &cancellables)

        // THEN - Spying works correctly to see what values are being hit

        // Spied call
        XCTAssertTrue(serviceSpy.loadResourceCalled)

        // Spied values
        XCTAssertNotNil(serviceSpy.url)
        XCTAssertEqual(
            serviceSpy.url?.absoluteString,
            "https://api.neds.com.au/rest/v1/racing/"
        )
        XCTAssertNotNil(serviceSpy.parameters)
        XCTAssertEqual(serviceSpy.parameters?.count, 2)

        XCTAssertEqual(serviceSpy.parameters?.first?.0, "method")
        XCTAssertEqual(serviceSpy.parameters?.first?.1.description, "nextraces")

        // NOTE: 🤚🏽🤚🏽 Interactor calls the lower level network service
        // always with `45` races to load and then it filters out from there
        // based on filters passed and number of races needed
        XCTAssertEqual(serviceSpy.parameters?.last?.0, "count")
        XCTAssertEqual(serviceSpy.parameters?.last?.1.description, "50")
    }

    func testLoadingWithHoseFilterOnly() throws {

        var receivedError: NetworkError?
        var receivedResponse: [Race]?

        // GIVEN - the interactor is made out of service mock that returns sample races
        let serviceMock = NetworkServiceMock(response: TestHelper.sampleRacesList, returningError: false)
        interactor = NextRacesInteractor(networkService: serviceMock)

        // WHEN - being requested to load 3 races for `horse`
        interactor.nextRaces(
            forCategories: [.horse],
            andCountry: nil,
            numberOfRaces: 3,
            hardNegativeTolerance: nil
        )
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received race response should be correct with
        // filtered category of race results

        XCTAssertEqual(receivedResponse?.count, 3)

        XCTAssertEqual(receivedResponse?[0].category, .horse)
        XCTAssertEqual(receivedResponse?[0].name, "1M Stakes")
        XCTAssertEqual(receivedResponse?[0].meeting, "Palermo")
        XCTAssertEqual(receivedResponse?[0].number, "11")
        XCTAssertEqual(receivedResponse?[0].venu.country, "ARG")
        XCTAssertEqual(receivedResponse?[0].venu.state, "ARG")
        XCTAssertEqual(receivedResponse?[0].startTime.timeIntervalSince1970, 1687208700)
        XCTAssertEqual(receivedResponse?[0].venu.state, "ARG")

        XCTAssertEqual(receivedResponse?[1].category, .horse)
        XCTAssertEqual(receivedResponse?[1].name, "Race 6 - Claiming")
        XCTAssertEqual(receivedResponse?[1].startTime.timeIntervalSince1970, 1687209900)

        XCTAssertEqual(receivedResponse?[2].category, .horse)
        XCTAssertEqual(receivedResponse?[2].name, "Race 2 - Premio Aiortrophe - 1999")
        XCTAssertEqual(receivedResponse?[2].startTime.timeIntervalSince1970, 1687210200)

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

    func testLoadingWithGreyhoundFilterOnly() throws {

        var receivedError: NetworkError?
        var receivedResponse: [Race]?

        // GIVEN - the interactor is made out of service mock that returns sample races
        let serviceMock = NetworkServiceMock(response: TestHelper.sampleRacesList, returningError: false)
        interactor = NextRacesInteractor(networkService: serviceMock)

        // WHEN - being requested to load 5 races for `greyhound`
        interactor.nextRaces(
            forCategories: [.greyhound],
            andCountry: nil,
            numberOfRaces: 5,
            hardNegativeTolerance: nil
        )
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received race response should be correct with
        // filtered category of race results.

        // Although searched for 5, but found actually 1 running :(
        // now out 45 max possible (total combining all types)
        // coming via lower level network service
        XCTAssertEqual(receivedResponse?.count, 1)

        XCTAssertEqual(receivedResponse?[0].category, .greyhound)
        XCTAssertEqual(receivedResponse?[0].name, "Red Snapper Seafoods, Christchurch C0")
        XCTAssertEqual(receivedResponse?[0].meeting, "Manawatu")
        XCTAssertEqual(receivedResponse?[0].number, "2")
        XCTAssertEqual(receivedResponse?[0].venu.country, "NZ")
        XCTAssertEqual(receivedResponse?[0].venu.state, "NZ")
        XCTAssertEqual(receivedResponse?[0].startTime.timeIntervalSince1970, 1687221000)

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

    func testLoadingWithGreyhoundHarnessFiltersOnly() throws {

        var receivedError: NetworkError?
        var receivedResponse: [Race]?

        // GIVEN - the interactor is made out of service mock that returns sample races
        let serviceMock = NetworkServiceMock(response: TestHelper.sampleRacesList, returningError: false)
        interactor = NextRacesInteractor(networkService: serviceMock)

        // WHEN - being requested to load 5 races for `greyhound` & `harness`
        interactor.nextRaces(
            forCategories: [.greyhound, .harness],
            andCountry: nil,
            numberOfRaces: 3,
            hardNegativeTolerance: nil
        )
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received race response should be correct with
        // filtered category of race results.

        // Although searched for 5, but found actually 1 running on each :(
        // now out 45 max possible (total combining all types)
        // coming via lower level network service. So total 2.

        XCTAssertEqual(receivedResponse?.count, 2)

        XCTAssertEqual(receivedResponse?[0].category, .harness)
        XCTAssertEqual(receivedResponse?[0].name, "Race 7 - 1609M")

        XCTAssertEqual(receivedResponse?[1].category, .greyhound)
        XCTAssertEqual(receivedResponse?[1].name, "Red Snapper Seafoods, Christchurch C0")

        // AND - the races are sorted

        XCTAssertTrue(
            receivedResponse![0].startTime.timeIntervalSince1970 < receivedResponse![1].startTime.timeIntervalSince1970
        )

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

    func testLoadingWithAllThreeFilters() throws {

        var receivedError: NetworkError?
        var receivedResponse: [Race]?

        // GIVEN - the interactor is made out of service mock that returns sample races
        let serviceMock = NetworkServiceMock(response: TestHelper.sampleRacesList, returningError: false)
        interactor = NextRacesInteractor(networkService: serviceMock)

        // WHEN - being requested to load 5 races combining all three categories
        interactor.nextRaces(
            forCategories: [.horse, .greyhound, .harness],
            andCountry: nil,
            numberOfRaces: 5,
            hardNegativeTolerance: nil
        )
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
            } receiveValue: { response in
                receivedResponse = response
            }
            .store(in: &cancellables)

        // THEN - received race response should be correct with
        // filtered category of race results. That is 5 total
        // combining all.
        // (There was 1 greyhound but missed out from top 5)
        // NOTE: See the business logic notes in the interactor code

        XCTAssertEqual(receivedResponse?.count, 5)

        XCTAssertEqual(receivedResponse?[0].category, .horse)
        XCTAssertEqual(receivedResponse?[1].category, .horse)
        XCTAssertEqual(receivedResponse?[2].category, .horse)
        XCTAssertEqual(receivedResponse?[3].category, .horse)

        // AND - the races are sorted
        XCTAssertTrue(
            receivedResponse![0].startTime.timeIntervalSince1970 < receivedResponse![1].startTime.timeIntervalSince1970
        )
        XCTAssertTrue(
            receivedResponse![1].startTime.timeIntervalSince1970 < receivedResponse![2].startTime.timeIntervalSince1970
        )
        XCTAssertTrue(
            receivedResponse![2].startTime.timeIntervalSince1970 < receivedResponse![3].startTime.timeIntervalSince1970
        )
        XCTAssertTrue(
            receivedResponse![3].startTime.timeIntervalSince1970 < receivedResponse![4].startTime.timeIntervalSince1970
        )

        XCTAssertEqual(receivedResponse?[4].category, .harness)
        XCTAssertEqual(receivedResponse?[4].name, "Race 7 - 1609M")
        XCTAssertEqual(receivedResponse?[4].number, "7")
        XCTAssertEqual(receivedResponse?[4].meeting, "Plainridge Racecourse")
        XCTAssertEqual(receivedResponse?[4].venu.country, "USA")
        XCTAssertEqual(receivedResponse?[4].venu.state, "MA")
        XCTAssertEqual(receivedResponse?[4].startTime.timeIntervalSince1970, 1687212000)

        // AND - there should not any error returned
        XCTAssertNil(receivedError)
    }

}
// swiftlint:enable force_unwrapping
