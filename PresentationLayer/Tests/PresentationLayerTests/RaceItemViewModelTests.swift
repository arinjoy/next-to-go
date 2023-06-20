//
//  Created by Arinjoy Biswas on 20/6/2023.
//

import XCTest
import Combine
@testable import DomainLayer
@testable import PresentationLayer

final class RaceItemViewModelTests: XCTestCase {

    private var testSubject: RaceItemViewModel!

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        // Take 3 minutes ahead from now
        var time = Date.now
        time.addTimeInterval(3 * 60)

        testSubject = .init(
            race: RaceMocks.race(withStartTime: time)
        )
    }

    override func tearDown() {
        testSubject = nil
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - Tests

    func testIconName() {
        XCTAssertEqual(testSubject.iconName, "greyhound")
    }

    func testRaceNumber() {
        XCTAssertEqual(
            testSubject.raceNumber,
            "next.togo.races.race.number.prefix".l10n() + "5"
        )
    }

    func testName() {
        XCTAssertEqual(testSubject.name, "The fast and furious")
    }

    func testDescription() {
        XCTAssertEqual(
            testSubject.description,
            "NY hounds on Fire"
        )
    }

    func testCountryEmoji() {
        XCTAssertEqual(testSubject.countryEmoji, "🇺🇸")
    }

    // TODO: Find a better way to unit test timer the logic
    func testCountdownText() {
        // Initial 2m 59s
        XCTAssertEqual(testSubject.countdownText, "2m 59s")

        let expectation1 = expectation(description: "exp one")
        testSubject.$countdownText.dropFirst(1).sink { _ in
            expectation1.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation1], timeout: 1.0)
        XCTAssertEqual(testSubject.countdownText, "2m 58s")
    }

    func testHighlightCountdownText() {
        XCTAssertTrue(testSubject.highlightCountdown)
    }

    func testCombinedAccessibilityLabel() {
        XCTAssertEqual(
            testSubject.combinedAccessibilityLabel,
            "next.togo.races.filter.greyhound.title".l10n()
            + ", The fast and furious, "
            + "next.togo.races.race.number.accessibility.label".l10n() + " \(5), " +
            "🇺🇸, NY hounds on Fire, 2minute 59second"
        )
    }

}
