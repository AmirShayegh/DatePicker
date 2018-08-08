//
//  DateExtention.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import Foundation

import Foundation

extension Date {

    func day() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }

    func day() -> Int {
        let cal = Calendar.current
        return cal.component(.day, from: self)
    }

    func month() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }

    func month() -> Int {
        let cal = Calendar.current
        return cal.component(.month, from: self)
    }

    func year() -> Int {
        let cal = Calendar.current
        return cal.component(.year, from: self)
    }

    func fromUTC(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_CA")
        return dateFormatter.date(from: string)!
    }

    func toUTC() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_CA")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSXXXXX"
        return formatter.string(from: self)
    }

    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
