//
//  NSAttributedString.swift
//  Extended
//
//  Created by Skyler Smith on 2018-11-09.
//

import Foundation


extension NSMutableAttributedString {
    private func currentParagraphStyle() -> NSMutableParagraphStyle {
        return length > 0 ? attributes(at: 0, effectiveRange: nil).first(where: { $0.key == .paragraphStyle })?.value as? NSMutableParagraphStyle ?? NSMutableParagraphStyle() : NSMutableParagraphStyle()
    }
    
    /// Add `kerning` to `self` and return `self`
    public func add(kerning: CGFloat) -> NSMutableAttributedString {
        addAttribute(.kern, value: kerning, range: NSMakeRange(0, length))
        return self
    }
    
    /// Add `lineSpacing` to `self` and return `self`
    public func add(lineSpacing: CGFloat) -> NSMutableAttributedString {
        let style = currentParagraphStyle()
        style.lineSpacing = lineSpacing
        addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, length))
        return self
    }
    
    /// Set the text alignment and return `self`
    public func aligned(_ alignment: NSTextAlignment) -> NSMutableAttributedString {
        let style = currentParagraphStyle()
        style.alignment = alignment
        addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, length))
        return self
    }
    
    // Set the foreground color and return `self`
    public func colored(_ color: UIColor) -> NSMutableAttributedString {
        addAttribute(.foregroundColor, value: color, range: NSMakeRange(0, length))
        return self
    }
    
    // Set the background color and return `self`
    public func backgroundColored(_ color: UIColor) -> NSMutableAttributedString {
        addAttribute(.backgroundColor, value: color, range: NSMakeRange(0, length))
        return self
    }
    
    // Set the underline color and style, and return `self`
    public func underlined(color: UIColor? = nil, style: NSUnderlineStyle = .single) -> NSMutableAttributedString {
        addAttribute(.underlineStyle, value: NSNumber(integerLiteral: style.rawValue), range: NSMakeRange(0, length))
        if let color = color {
            addAttribute(.underlineColor, value: color, range: NSMakeRange(0, length))
        }
        return self
    }
}
