//
//  UIView.swift
//  Extended
//
//  Created by Amir Shayegh on 2018-09-19.
//

import Foundation
import UIKit

extension UIView {

    // Find parent vc
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }

    // Load a nib
    public class func fromNib<T: UIView>(bundle: Bundle? = Bundle.main) -> T {
        return bundle!.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    public func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    public func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

}
