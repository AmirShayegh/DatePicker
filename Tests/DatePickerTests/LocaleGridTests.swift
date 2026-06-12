//
//  LocaleGridTests.swift
//  DatePickerTests
//

import XCTest
@testable import DatePicker

final class LocaleGridTests: XCTestCase {

    private func helper(locale: String) -> DatePickerHelper {
        let h = DatePickerHelper()
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: locale)
        cal.timeZone = TimeZone(identifier: "UTC")!
        h.calendar = cal
        return h
    }

    // Issue #19: the weekday header must start at the calendar's first
    // weekday, not always at Sunday.
    func testWeekdayHeaderStartsAtCalendarFirstWeekday() {
        for locale in ["en_US", "fr_FR", "de_DE", "nl_NL", "ar_SA"] {
            let h = helper(locale: locale)
            let days = h.days()
            XCTAssertEqual(days.count, 7, "locale \(locale)")
            let expectedFirst = h.calendar.shortWeekdaySymbols[h.calendar.firstWeekday - 1]
            XCTAssertEqual(days.first, expectedFirst, "locale \(locale)")
        }
    }

    func testWeekdayHeaderIsRotationOfSymbols() {
        for locale in ["en_US", "fr_FR", "de_DE", "nl_NL", "ar_SA"] {
            let h = helper(locale: locale)
            XCTAssertEqual(Set(h.days()), Set(h.calendar.shortWeekdaySymbols), "locale \(locale)")
        }
    }

    // June 1, 2026 is a Monday. In a Sunday-first grid it lands in
    // column 1; in a Monday-first grid it lands in column 0.
    func testFirstWeekdayColumnRespectsWeekStart() {
        let us = helper(locale: "en_US")
        XCTAssertEqual(us.calendar.firstWeekday, 1, "en_US should be Sunday-first")
        XCTAssertEqual(us.firstWeekdayColumn(month: 6, year: 2026), 1)

        let fr = helper(locale: "fr_FR")
        XCTAssertEqual(fr.calendar.firstWeekday, 2, "fr_FR should be Monday-first")
        XCTAssertEqual(fr.firstWeekdayColumn(month: 6, year: 2026), 0)
    }

    // September 1, 2020 is a Tuesday — the configuration from the
    // issue #19 screenshots (Dutch locale).
    func testIssue19Repro() {
        let us = helper(locale: "en_US")
        XCTAssertEqual(us.firstWeekdayColumn(month: 9, year: 2020), 2)

        let nl = helper(locale: "nl_NL")
        XCTAssertEqual(nl.calendar.firstWeekday, 2, "nl_NL should be Monday-first")
        XCTAssertEqual(nl.firstWeekdayColumn(month: 9, year: 2020), 1)
    }

    // The column must always leave room for the longest month:
    // header row (7) + column offset + 31 days must fit in the 49-cell grid.
    func testGridCapacityInAllLocales() {
        for locale in ["en_US", "fr_FR", "de_DE", "nl_NL", "ar_SA", "fa_IR"] {
            let h = helper(locale: locale)
            for year in [2020, 2024, 2026] {
                for month in 1...12 {
                    let column = h.firstWeekdayColumn(month: month, year: year)
                    XCTAssertTrue((0..<7).contains(column), "column out of range for \(locale) \(year)-\(month)")
                    XCTAssertLessThanOrEqual(7 + column + h.daysIn(month: month, year: year), 49,
                                             "grid overflow for \(locale) \(year)-\(month)")
                }
            }
        }
    }
}
