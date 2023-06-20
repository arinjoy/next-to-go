//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import XCTest
import Combine
@testable import DomainLayer
@testable import PresentationLayer

final class FiltersViewModelTests: XCTestCase {

    var testSubject: FiltersViewModel!

    // MARK: - Lifecycle

    override func setUp() {
        testSubject = FiltersViewModel()
        super.setUp()
    }

    override func tearDown() {
        testSubject = nil
        super.tearDown()
    }


    // MARK: - Tests

    func testInitialStates() {

        // WHEN
        let filters = testSubject.filters

        // THEN - there should 3 filters
        XCTAssertEqual(filters.count, 3)

        // AND - each of the filter comes with `selected` true to begin with
        // AND - their display icons and accessibility labels are correct

        XCTAssertEqual(filters[0].category, .horse)
        XCTAssertTrue(filters[0].selected)
        XCTAssertEqual(filters[0].category.iconName, "horse")
        XCTAssertEqual(
            filters[0].category.accessibilityLabel,
            "next.togo.races.filter.horse.title".l10n()
        )


        XCTAssertEqual(filters[1].category, .greyhound)
        XCTAssertTrue(filters[1].selected)
        XCTAssertEqual(filters[1].category.iconName, "greyhound")
        XCTAssertEqual(
            filters[1].category.accessibilityLabel,
            "next.togo.races.filter.greyhound.title".l10n()
        )

        XCTAssertEqual(filters[2].category, .harness)
        XCTAssertTrue(filters[2].selected)
        XCTAssertEqual(filters[2].category.iconName, "harness")
        XCTAssertEqual(
            filters[2].category.accessibilityLabel,
            "next.togo.races.filter.harness.title".l10n()
        )
    }

    func testFilterSelectionsAndDeselections() {

        let filters = testSubject.filters

        let filterOne = filters[0]
        let filterTwo = filters[1]
        let filterThree = filters[2]

        // WHEN - first one is tapped
        testSubject.filterItemTapped(filterItem: filterOne)
        // THEN - it's get un-selected
        XCTAssertFalse(testSubject.filters[0].selected)

        // WHEN - first one tapped again
        testSubject.filterItemTapped(filterItem: filterOne)
        // THEN - it's get selected
        XCTAssertTrue(testSubject.filters[0].selected)

        // WHEN - second one is tapped
        testSubject.filterItemTapped(filterItem: filterTwo)
        // THEN - it's get un-selected
        XCTAssertFalse(testSubject.filters[1].selected)

        // WHEN - third one is tapped
        testSubject.filterItemTapped(filterItem: filterThree)
        // THEN - it's get un-selected
        XCTAssertFalse(testSubject.filters[2].selected)

        // NOTE: at this stage there two un-selected (2nd and 3rd)
        // and one selected (1st)

        // WHEN - first one is tapped
        testSubject.filterItemTapped(filterItem: filterOne)

        // THEN - all 3 becomes selected
        // Because we don't support all 3 to be un-selected at once
        // Check the UI and logic
        XCTAssertTrue(testSubject.filters[0].selected)
        XCTAssertTrue(testSubject.filters[1].selected)
        XCTAssertTrue(testSubject.filters[2].selected)
    }

    func testFilterSelectionActionTriggers() {
        var callCount: Int = 0

        testSubject.filterTappedAction = {
            callCount += 1
            XCTAssert(true, "Filer tap action executed")
        }

        let filters = testSubject.filters
        let filterOne = filters[0]
        let filterTwo = filters[1]
        let filterThree = filters[2]

        // WHEN - first one is tapped
        testSubject.filterItemTapped(filterItem: filterOne)
        // THEN - tap action was called
        XCTAssertEqual(callCount, 1)

        // WHEN - second one is tapped
        testSubject.filterItemTapped(filterItem: filterTwo)
        // THEN - tap action was called again
        XCTAssertEqual(callCount, 2)

        // WHEN - third one is tapped
        testSubject.filterItemTapped(filterItem: filterThree)
        // THEN - tap action was called again
        XCTAssertEqual(callCount, 3)

        // WHEN - first one is tapped again
        testSubject.filterItemTapped(filterItem: filterOne)
        // THEN - tap action was called again
        XCTAssertEqual(callCount, 4)

        // WHEN - third one is tapped again
        testSubject.filterItemTapped(filterItem: filterTwo)
        // THEN - tap action was called again
        XCTAssertEqual(callCount, 5)
    }

}
