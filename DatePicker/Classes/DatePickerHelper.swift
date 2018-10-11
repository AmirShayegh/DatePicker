//
//  FreshDateHelper.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import Foundation
import Extended


public class DatePickerHelper {
    public static let shared = DatePickerHelper()
    static let minYear: Int = 2018
    static let maxYear: Int = 2100
    var monthsList: [String] = [String]()
    var daysList: [String] = [String]()
    private init() {}

    // Returns String array of months
    public func months() -> [String] {
        if monthsList.count == 12 {
            return monthsList
        }
        var returnValue: [String] = [String]()
        let formatter = DateFormatter()
        if let months = formatter.monthSymbols {
            returnValue = months
        }
        self.monthsList = returnValue
        return returnValue
    }

    public func days() -> [String] {
        if daysList.count == 7 {
            return daysList
        }
        var returnValue: [String] = [String]()
        let formatter = DateFormatter()
        if let months = formatter.shortWeekdaySymbols {
            returnValue = months
        }
        self.daysList = returnValue
        return returnValue
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
        if let m = months.index(of: name) {
            return m + 1
        }
        return 0
    }

    // Returns Number of days in month in given year
    public func daysIn(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)

        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents), let range = calendar.range(of: .day, in: .month, for: date)  {
            return range.count
        } else {
            return 0
        }
    }

    // Rerturns day of the given date
//    func day(in date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE"
//        return formatter.string(from: date)
//
//       // Note: this would return day number.
//       // return Calendar.current.component(.weekday, from: date)
//    }

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

    // Generates date object from given month and year
    public func dateFrom(month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = 0
        dateComponents.minute = 0

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }

    // Generates date object from day montha and year
    public func dateFrom(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = 0
        dateComponents.minute = 0

        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }

    func test() {
        print("*** Testing Month number and name conversion functions ***")
        for i in 1...12 {
            print("\(i): \(DatePickerHelper.shared.month(name: months()[i-1])) is \(DatePickerHelper.shared.month(number: i))")
        }

        print("**** Testing First days of months ***")
        for i in 2010...2025 {
            for j in 1...12 {
                print("Year: \(i), Month: \(DatePickerHelper.shared.month(number: j)), First Day: \(firstDayOf(month: j, year: i)), there are \(daysIn(month: j, year: i)) days in this month, and the last day is \(lastDayOf(month: j, year: i).charactersUpTo(index: 3))")
            }
        }

    }
}
