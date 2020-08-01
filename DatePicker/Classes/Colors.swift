//
//  Colors.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import Foundation
import UIKit

class Colors {
    
    public static var backgroundLight: UIColor = UIColor(hex: "#FAFAFA")
    public static var mainLight: UIColor = UIColor(hex: "#234075")
    public static var inactiveTextLight: UIColor = UIColor(hex: "#CDCED2")
    
    public static var backgroundDark: UIColor = UIColor(hex: "#FAFAFA")
    public static var mainDark: UIColor = UIColor(hex: "#234075")
    public static var inactiveTextDark: UIColor = UIColor(hex: "#CDCED2")
    
    public static var background: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(hex: "#14293E")
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
                    return UIColor.white.withAlphaComponent(0.75)
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
                    return UIColor(hex: "#14293E")
                } else {
                    return inactiveTextLight
                }
            }
        } else {
            return inactiveTextLight
        }
    }()
}
