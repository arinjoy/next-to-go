import XCTest
@testable import SharedUtils

final class CountryUtilityTests: XCTestCase {

    func testCountryCodeFrom2to3() {

        XCTAssertEqual(CountryUtilities.getAlpha3Code(byAlpha2Code: "AU"), "AUS")
        XCTAssertEqual(CountryUtilities.getAlpha3Code(byAlpha2Code: "BR"), "BRA")
        XCTAssertEqual(CountryUtilities.getAlpha3Code(byAlpha2Code: "DK"), "DNK")
        XCTAssertEqual(CountryUtilities.getAlpha3Code(byAlpha2Code: "JP"), "JPN")

        // And test so one, better via array looping iteration
    }

    func testCountryCodeFrom3to2() {

        XCTAssertEqual(CountryUtilities.getAlpha2Code(byAlpha3Code: "USA"), "US")
        XCTAssertEqual(CountryUtilities.getAlpha2Code(byAlpha3Code: "CHN"), "CN")
        XCTAssertEqual(CountryUtilities.getAlpha2Code(byAlpha3Code: "IND"), "IN")
        XCTAssertEqual(CountryUtilities.getAlpha2Code(byAlpha3Code: "KOR"), "KR")
        XCTAssertEqual(CountryUtilities.getAlpha2Code(byAlpha3Code: "PAK"), "PK")

        // And test so one, better via array looping iteration
    }

}
