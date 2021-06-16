//
//  Double.swift
//  Extended
//
//  Created by Amir Shayegh on 2018-10-02.
//

import Foundation
import UIKit

extension Double {
    public func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
