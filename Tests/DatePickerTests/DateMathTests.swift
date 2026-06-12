//
//  DateMathTests.swift
//  DatePickerTests
//

import XCTest
@testable import DatePicker

final class DateMathTests: XCTestCase {

    private func helper(timeZone: String, locale: String = "en_US") -> DatePickerHelper {
        let h = DatePickerHelper()
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: timeZone)!
        cal.locale = Locale(identifier: locale)
        h.calendar = cal
        return h
    }

    // Issue #24: selecting July 1 must never come back as June 30,
    // in any time zone, including half-hour offsets and DST edges.
    func testDateRoundTripAcrossTimeZones() {
        let zones = [
            "UTC",
            "America/New_York",
            "America/Sao_Paulo",
            "Asia/Tehran",
            "Asia/Kolkata",
            "Australia/Sydney",
            "Pacific/Kiritimati",
        ]
        let cases: [(day: Int, month: Int, year: Int)] = [
            (1, 7, 2021),    // the issue #24 repro
            (30, 6, 2021),
            (1, 1, 2026),
            (31, 12, 2025),
            (29, 2, 2024),   // leap day
            (8, 3, 2026),    // US spring-forward day
            (5, 4, 2026),    // Sydney DST end
        ]
        for zone in zones {
            let h = helper(timeZone: zone)
            for c in cases {
                guard let date = h.dateFrom(day: c.day, month: c.month, year: c.year) else {
                    XCTFail("Could not build \(c.year)-\(c.month)-\(c.day) in \(zone)")
                    continue
                }
                XCTAssertEqual(h.calendar.component(.day, from: date), c.day, "day mismatch in \(zone)")
                XCTAssertEqual(h.calendar.component(.month, from: date), c.month, "month mismatch in \(zone)")
                XCTAssertEqual(h.calendar.component(.year, from: date), c.year, "year mismatch in \(zone)")
            }
        }
    }

    // Sao Paulo's DST used to skip midnight entirely (e.g. 2018-11-04
    // had no 00:00). Building from year/month/day only must still
    // produce a date inside the requested day.
    func testMidnightSkippingDSTTransition() {
        let h = helper(timeZone: "America/Sao_Paulo")
        guard let date = h.dateFrom(day: 4, month: 11, year: 2018) else {
            return XCTFail("Could not build 2018-11-04 in America/Sao_Paulo")
        }
        XCTAssertEqual(h.calendar.component(.day, from: date), 4)
        XCTAssertEqual(h.calendar.component(.month, from: date), 11)
        XCTAssertEqual(h.calendar.component(.year, from: date), 2018)
    }

    func testDaysInMonth() {
        let h = helper(timeZone: "UTC")
        XCTAssertEqual(h.daysIn(month: 2, year: 2024), 29)
        XCTAssertEqual(h.daysIn(month: 2, year: 2100), 28)
        XCTAssertEqual(h.daysIn(month: 1, year: 2026), 31)
        XCTAssertEqual(h.daysIn(month: 4, year: 2026), 30)
        XCTAssertEqual(h.daysIn(month: 12, year: 2026), 31)
    }

    func testMonthNameNumberRoundTrip() {
        let h = helper(timeZone: "UTC")
        XCTAssertEqual(h.months().count, 12)
        for number in 1...12 {
            XCTAssertEqual(h.month(name: h.month(number: number)), number)
        }
        XCTAssertEqual(h.month(number: 0), "")
        XCTAssertEqual(h.month(number: 13), "")
        XCTAssertEqual(h.month(name: "NotAMonth"), 0)
    }
}
