//
//  Created by Arinjoy Biswas on 21/6/2023.
//

import Foundation
import XCTest
@testable import SharedUtils

final class TimerCountdownTests: XCTestCase {

    var subject: TimeInterval!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        subject = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testTimerHourMinutesSecondsLeft() {

        subject = Date.now.timeIntervalSinceNow + 4 * 60 * 60 + 20
        XCTAssertEqual(subject.hoursMinutesSeconds, "4h")

        subject = Date.now.timeIntervalSinceNow + 1 * 60 * 60 + 20 * 60
        XCTAssertEqual(subject.hoursMinutesSeconds, "1h 20m")

        subject = Date.now.timeIntervalSinceNow + 5 * 60 + 2
        XCTAssertEqual(subject.hoursMinutesSeconds, "5m")

        subject = Date.now.timeIntervalSinceNow + 4 * 60
        XCTAssertEqual(subject.hoursMinutesSeconds, "4m")

        subject = Date.now.timeIntervalSinceNow + 2 * 60 + 34
        XCTAssertEqual(subject.hoursMinutesSeconds, "2m 34s")

        subject = Date.now.timeIntervalSinceNow + 1 * 60 + 25
        XCTAssertEqual(subject.hoursMinutesSeconds, "1m 25s")

        subject = Date.now.timeIntervalSinceNow + 28
        XCTAssertEqual(subject.hoursMinutesSeconds, "28s")

        subject = Date.now.timeIntervalSinceNow + 5
        XCTAssertEqual(subject.hoursMinutesSeconds, "5s")

        subject = Date.now.timeIntervalSinceNow - 20
        XCTAssertEqual(subject.hoursMinutesSeconds, "-20s")

        subject = Date.now.timeIntervalSinceNow - (1 * 60 + 22)
        XCTAssertEqual(subject.hoursMinutesSeconds, "-1m -22s")
    }

    func testShouldHighlight() {

        subject = Date.now.timeIntervalSinceNow + 4 * 60 * 60 + 20
        XCTAssertFalse(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow + 1 * 60 * 60 + 20 * 60
        XCTAssertFalse(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow + 5 * 60 + 2
        XCTAssertFalse(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow + 4 * 60
        XCTAssertTrue(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow + 1 * 60 + 25
        XCTAssertTrue(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow + 5
        XCTAssertTrue(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow - 20
        XCTAssertTrue(subject.shouldHighlight)

        subject = Date.now.timeIntervalSinceNow - (1 * 60 + 22)
        XCTAssertTrue(subject.shouldHighlight)
    }

}
