//
//  Extensions.swift
//  
//
//  Created by Radu Ursache on 16.06.2021.
//

import Foundation
import UIKit

extension UIView {
	func asImage() -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
}

extension UICollectionView {
	var centerPoint : CGPoint {
		get {
			return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
		}
	}

	var centerCellIndexPath: IndexPath? {
		if let centerIndexPath: IndexPath  = self.indexPathForItem(at: self.centerPoint) {
			return centerIndexPath
		}
		return nil
	}
}

extension Date {
	func day() -> Int {
		return self.get(.day)
	}
	
	func month() -> Int {
		return self.get(.month)
	}
	
	func year() -> Int {
		return self.get(.year)
	}

	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		return calendar.component(component, from: self)
	}
}

extension UIColor {
	convenience init(hex: String) {
		let r, g, b, a: CGFloat

		let start = hex.index(hex.startIndex, offsetBy: hex.hasPrefix("#") ? 1 : 0)
		let hexColor = String(hex[start...])
		let scanner = Scanner(string: hexColor)
		var hexNumber: UInt64 = 0
		
		if scanner.scanHexInt64(&hexNumber) {
			if hexColor.count == 8 {
				r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
				g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
				b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
				a = CGFloat(hexNumber & 0x000000ff) / 255
			} else if hexColor.count == 6 {
				r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
				g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
				b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
				a = CGFloat(1.0)
			} else {
				self.init(red: 0, green: 0, blue: 0, alpha: 1)
				return
			}

			self.init(red: r, green: g, blue: b, alpha: a)
			return
		}

		self.init(red: 0, green: 0, blue: 0, alpha: 1)
	}
}
