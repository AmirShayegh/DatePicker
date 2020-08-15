//
//  Colors.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import Foundation
import UIKit

class DatePickerColors {
    
    public static var backgroundLight: UIColor = UIColor(hex: "#FAFAFA")
    public static var mainLight: UIColor = UIColor(hex: "#234075")
    public static var inactiveTextLight: UIColor = UIColor(hex: "#CDCED2")
    public static var backdropLight: UIColor = UIColor.white.withAlphaComponent(0.5)
    
    public static var backgroundDark: UIColor = UIColor(hex: "#2e2e2e")
    public static var mainDark: UIColor = UIColor.white.withAlphaComponent(0.9)
    public static var inactiveTextDark: UIColor = UIColor(hex: "#616161")
    public static var backdropDark: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    public static var backdrop: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return backdropDark
                } else {
                    return backdropLight
                }
            }
        } else {
            return backdropLight
        }
    }()
    
    public static var background: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return backgroundDark
                } else {
                    return backgroundLight
                }
            }
        } else {
            return backgroundLight
        }
    }()
    
    public static var main: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return mainDark
                } else {
                    return mainLight
                }
            }
        } else {
            return mainLight
        }
    }()
    
    public static var inactiveText: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return inactiveTextDark
                } else {
                    return inactiveTextLight
                }
            }
        } else {
            return inactiveTextLight
        }
    }()
}
