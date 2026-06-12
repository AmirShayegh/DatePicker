//
//  DateMathTests.swift
//  DatePickerTests
//

import XCTest
@testable import DatePicker

final class DateMathTests: XCTestCase {

    func testDaysInMonth() {
        let helper = DatePickerHelper()
        XCTAssertEqual(helper.daysIn(month: 2, year: 2024), 29)
        XCTAssertEqual(helper.daysIn(month: 2, year: 2100), 28)
        XCTAssertEqual(helper.daysIn(month: 1, year: 2026), 31)
        XCTAssertEqual(helper.daysIn(month: 4, year: 2026), 30)
    }
}
