//
//  StringExtention.swift
//  DatePicker
//
//  Created by Amir Shayegh on 2018-08-15.
//

import Foundation
extension UIView {
    func image() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
