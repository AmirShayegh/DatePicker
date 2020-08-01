//
//  String.swift
//  Extentions
//
//  Created by Amir Shayegh on 2018-09-19.
//

import Foundation
extension String {
    public var isInt: Bool {
        return Int(self) != nil
    }
    public var isDouble: Bool {
        return Double(self) != nil
    }

    public func replacingLastOccurrenceOfString(_ searchString: String, with replacementString: String, caseInsensitive: Bool = true) -> String {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }

        if let range = self.range(of: searchString, options: options, range: nil, locale: nil) {

            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }

    public func convertFromCamelCase() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return ($0 + " " + String($1))
                }
            }
            return $0 + String($1)
        }
    }

    public func removeWhitespaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.height)
    }

    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.width)
    }

    public func charactersUpTo(index: Int) -> String {
        return String(self.prefix(index))
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    public var fromHTML: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public func attributable() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}
