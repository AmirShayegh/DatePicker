//
//  FreshDateHelper.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import Foundation


public class DatePickerHelper {
    public static let shared = DatePickerHelper()
    static let minYear: Int = 2018
    static let maxYear: Int = 2100

    // The calendar used for all date math. Injectable for tests.
    var calendar: Calendar = .current

    init() {}

    // Returns String array of localized month names
    public func months() -> [String] {
        return calendar.monthSymbols
    }

    // Returns String array of localized short weekday names,
    // ordered by the calendar's first weekday so that grids built
    // from this array align in every locale.
    public func days() -> [String] {
        let symbols = calendar.shortWeekdaySymbols
        let shift = calendar.firstWeekday - 1
        return Array(symbols[shift...]) + Array(symbols[..<shift])
    }

    // Returns the name of the month for given month number
    public func month(number: Int) -> String {
        if number < 1 || number > 12 {
            return ""
        }
        let months = self.months()
        return months[number - 1]
    }

    // Returns the number of the month for given month name
    public func month(name: String) -> Int {
        let months = self.months()
        if let m = months.firstIndex(of: name) {
            return m + 1
        }
        return 0
    }

    // Returns Number of days in month in given year
    public func daysIn(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        if let date = calendar.date(from: dateComponents), let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        } else {
            return 0
        }
    }

    // Returns the first day of the given month/year
    public func firstDayOf(month: Int, year: Int) -> String {
        if let date = dateFrom(month: month, year: year) {
            return date.day()
        } else {
            return ""
        }
    }

    // Returns the last day of given month/year
    public func lastDayOf(month: Int, year: Int) -> String {
        if let date = dateFrom(day: daysIn(month: month, year: year), month: month, year: year) {
            return date.day()
        } else {
            return ""
        }
    }

    // Zero-based column of the month's first day in a week grid that
    // starts at the calendar's first weekday. Computed numerically so
    // it never depends on localized weekday strings.
    func firstWeekdayColumn(month: Int, year: Int) -> Int {
        guard let date = dateFrom(month: month, year: year) else { return 0 }
        let weekday = calendar.component(.weekday, from: date)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    // Generates date object from given month and year
    public func dateFrom(month: Int, year: Int) -> Date? {
        return dateFrom(day: 1, month: month, year: year)
    }

    // Generates the first valid instant of the given local day.
    // Building from year/month/day only (no explicit time zone or
    // midnight components) lets the calendar handle DST transitions
    // where midnight does not exist.
    public func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents)
    }
}
