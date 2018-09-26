//
//  TimeInterval.swift
//  Extended
//
//  Created by Amir Shayegh on 2018-09-19.
//

import Foundation
extension TimeInterval {
    public var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    public var seconds: Int {
        return Int(self) % 60
    }

    public var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    public var hours: Int {
        return Int(self) / 3600
    }

    public var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}
