//
//  UILabel.swift
//  Extended
//
//  Created by Amir Shayegh on 2018-09-19.
//

import Foundation
extension UILabel {
    public func increaseFontSize(by: CGFloat) {
        let size = self.font.pointSize
        self.font = self.font.withSize(size + by)
    }

    public func change(kernValue: Double) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            let textRange = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: textRange)
            self.attributedText = attributedString
            self.sizeToFit()
        }
    }
}
