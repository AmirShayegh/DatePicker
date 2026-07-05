//
//  PickerModelTests.swift
//  DatePickerTests
//
//  Model-level regressions for the day/year selection logic, exercised
//  without a hosted view (effectiveDay/daysInMonth/getYearsList read no
//  outlets).
//

import XCTest
@testable import DatePicker

final class PickerModelTests: XCTestCase {

    private var savedCalendar: Calendar!

    override func setUp() {
        super.setUp()
        // Deterministic Gregorian calendar for the shared helper that
        // PickerViewController reads through.
        savedCalendar = DatePickerHelper.shared.calendar
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        cal.locale = Locale(identifier: "en_US")
        DatePickerHelper.shared.calendar = cal
    }

    override func tearDown() {
        DatePickerHelper.shared.calendar = savedCalendar
        super.tearDown()
    }

    // The intended day survives a scroll through a shorter month.
    // Previously month/year didSet permanently shrank `day`, so
    // 31 -> February -> December came back as the 30th.
    func testEffectiveDayPreservesIntendedDayAcrossShortMonths() {
        let vc = PickerViewController()
        vc.mode = .Basic
        vc.year = 2021
        vc.day = 31

        vc.month = 1                    // January (31)
        XCTAssertEqual(vc.effectiveDay(), 31)

        vc.month = 2                    // February (28) — clamped for render/return
        XCTAssertEqual(vc.effectiveDay(), 28)
        XCTAssertEqual(vc.day, 31, "intended day must not be mutated")

        vc.month = 9                    // September (30)
        XCTAssertEqual(vc.effectiveDay(), 30)

        vc.month = 12                   // December (31) — intended day restored
        XCTAssertEqual(vc.effectiveDay(), 31)
        XCTAssertEqual(vc.day, 31)
    }

    // Yearless mode has no real year; February must still offer the 29th.
    func testYearlessFebruaryAllows29() {
        let vc = PickerViewController()
        vc.mode = .Yearless
        vc.month = 2
        XCTAssertEqual(vc.daysInMonth(), 29)
        vc.day = 29
        XCTAssertEqual(vc.effectiveDay(), 29)
    }

    // A selected year outside the default 2018...2100 window (e.g. a
    // birthdate) must appear in the wheel list rather than be discarded.
    func testYearsListIncludesOutOfRangeSelectedYear() {
        let vc = PickerViewController()
        vc.mode = .Basic

        vc.year = 1990
        let past = vc.getYearsList()
        XCTAssertEqual(past.first, 1990)
        XCTAssertTrue(past.contains(1990))
        XCTAssertTrue(past.contains(2018))
        XCTAssertTrue(past.contains(2100))

        vc.year = 2200
        let future = vc.getYearsList()
        XCTAssertEqual(future.last, 2200)
        XCTAssertTrue(future.contains(2018))
    }
}
