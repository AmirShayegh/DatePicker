//
//  Extensions.swift
//  DatePicker
//
//  Internal replacements for the extensions previously provided by the
//  unmaintained Extended pod. Kept internal so they don't leak into
//  consumers' namespaces.
//

import UIKit

extension Date {

    // Localized weekday name, e.g. "Sunday" or "Sun".
    func day(shortHand: Bool? = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        if let short = shortHand, short {
            return String(formatter.string(from: self).prefix(3))
        }
        return formatter.string(from: self)
    }

    func day() -> Int {
        return DatePickerHelper.shared.calendar.component(.day, from: self)
    }

    func month() -> Int {
        return DatePickerHelper.shared.calendar.component(.month, from: self)
    }

    func year() -> Int {
        return DatePickerHelper.shared.calendar.component(.year, from: self)
    }
}

extension UIView {
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UICollectionView {
    var centerPoint: CGPoint {
        return CGPoint(x: center.x + contentOffset.x, y: center.y + contentOffset.y)
    }

    var centerCellIndexPath: IndexPath? {
        return indexPathForItem(at: centerPoint)
    }
}

extension String {
    func charactersUpTo(index: Int) -> String {
        return String(prefix(index))
    }
}

extension UIColor {
    convenience init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        guard cString.count == 6 else {
            self.init(white: 0.5, alpha: 1)
            return
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}
