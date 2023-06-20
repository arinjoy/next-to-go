//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import XCTest
import Combine
@testable import DataLayer
@testable import DomainLayer
@testable import PresentationLayer

final class NextToGoViewModelTests: XCTestCase {

    // MARK: - Properties

    private var testSubject: NextToGoViewModel!

    private var cancellables = Set<AnyCancellable>()

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

    func testInitialLoadingPlaceholdersState() throws {

        // GIVEN - viewModel is configured
        testSubject = NextToGoViewModel(interactor: NextRacesInteractorMock())

        // THEN - initial loading state should be correct with placeholders shimmer items
        switch testSubject.loadingState {
        case .loading(let placeholders):

            // AND - There should be 5 shimmering items
            XCTAssertEqual(placeholders.count, 5)
            XCTAssertEqual(placeholders.first?.name, "Lorem ipsum dolor")
            XCTAssertEqual(placeholders.first?.meeting, "Lorem ipsum")
            XCTAssertEqual(placeholders.first?.venu.country, "AUS")

        default:
            XCTFail("Initial state must be loading with placeholders for shimmers)")
        }
    }

    func testLoadRacesCallsInteractor() throws {

        let expectation = expectation(description: "Race items must be loaded from interactor")

        let interactorSpy = NextRacesInteractorSpy()

        // GIVEN - viewModel is configured with interactor spy
        testSubject = NextToGoViewModel(interactor: interactorSpy)

        // WHEN - next races are requested to be loaded
        testSubject.loadNextRaces()

        testSubject.$loadingState.dropFirst().sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - interactor's method is being called
        XCTAssertTrue(interactorSpy.nextRacesCalled)
    }

    func testLoadRacesSuccessfulNonEmpty() throws {

        let expectation = expectation(description: "Race items must be loaded from interactor")

        let interactorMock = NextRacesInteractorMock(returningError: false)

        // GIVEN - viewModel is configured with interactor that provides sample non empty list
        testSubject = NextToGoViewModel(interactor: interactorMock)

        // WHEN - next races are requested to be loaded
        testSubject.loadNextRaces()

        testSubject.$loadingState.dropFirst(2).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - loading state should be correct with contents loaded
        switch testSubject.loadingState {
        case .loaded(let contents):

            // AND - There should be 6 race items
            XCTAssertEqual(contents.count, 6)

            XCTAssertEqual(contents.first?.name, "Red Snapper Seafoods, Christchurch C0")
            XCTAssertEqual(contents.first?.meeting, "Manawatu")
            XCTAssertEqual(contents.first?.venu.country, "NZ")

            /// Test transformation logic of
            /// `DomainLayer.Race` -> `PresentationLayer.RacePresentationItem`
            /// in separate test file.

        default:
            XCTFail("Loading state must be loaded with contents")
        }
    }

    func testLoadRacesSuccessfulEmpty() throws {

        let expectation = expectation(description: "Empty list must be loaded from interactor")

        let interactorMock = NextRacesInteractorMock(returningError: false, resultingData: [])

        // GIVEN - viewModel is configured with interactor that supposed to be passing with empty list
        testSubject = NextToGoViewModel(interactor: interactorMock)

        // WHEN - next races are requested to be loaded
        testSubject.loadNextRaces()

        testSubject.$loadingState.dropFirst(2).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - loading state should become empty
        switch testSubject.loadingState {
        case .empty:
            break
        default:
            XCTFail("Loading state must be empty")
        }
    }

    func testLoadRacesFailure() throws {

        let expectation = expectation(description: "Error must be loaded from interactor")

        let interactorSpy = NextRacesInteractorMock(returningError: true, error: .networkFailure)

        // GIVEN - viewModel is configured with interactor mock that supposed to failing
        testSubject = NextToGoViewModel(interactor: interactorSpy)

        // WHEN - next races are requested to be loaded
        testSubject.loadNextRaces()

        testSubject.$loadingState.dropFirst(2).sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)

        // THEN - loading state should become error
        switch testSubject.loadingState {
        case .error(let error):

            // AND - error type returned is the expected one
            XCTAssertEqual(error as! NetworkError, .networkFailure) // swiftlint:disable:this force_cast

        default:
            XCTFail("Loading state must be error")
        }
    }

    func testFilterViewModel() throws {

        // GIVEN - viewModel is loaded
        testSubject = NextToGoViewModel(interactor: NextRacesInteractorMock())

        let filters = testSubject.filterViewModel.filters

        // THEN - the child filter viewModel would have 3 filters in it
        XCTAssertEqual(filters.count, 3)

        // AND - each of the filter comes with `selected` true to begin with
        XCTAssertEqual(filters[0].category, .horse)
        XCTAssertTrue(filters[0].selected)

        XCTAssertEqual(filters[1].category, .greyhound)
        XCTAssertTrue(filters[1].selected)

        XCTAssertEqual(filters[2].category, .harness)
        XCTAssertTrue(filters[1].selected)
    }

}
