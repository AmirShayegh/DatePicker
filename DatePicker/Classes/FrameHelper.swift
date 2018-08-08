//
//  FrameHelper.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-07.
//

import Foundation

class FrameHelper {
    static let shared = FrameHelper()

    var parent: UIViewController?

    var viewWidth: CGFloat = 200
    var viewHeight: CGFloat = (200 * 1.4)

    private init() {}

    // MARK: Positioning
    func centerViewInParent(view: UIView, in parentVC: UIViewController? = nil) {
        guard let p = parentVC else {return}
        view.center.x = p.view.center.x
        view.center.y = p.view.center.y
        view.centerXAnchor.constraint(equalTo: p.view.centerXAnchor)
        view.centerYAnchor.constraint(equalTo: p.view.centerYAnchor)
    }

    func sizeAndCenter(view:UIView, in parentVC: UIViewController) {
        view.frame = getSuggesedFrame(parentVC: parentVC)
        view.center.x = parentVC.view.center.x
        view.center.y = parentVC.view.center.y
        view.centerXAnchor.constraint(equalTo: parentVC.view.centerXAnchor)
        view.centerYAnchor.constraint(equalTo: parentVC.view.centerYAnchor)
    }

    // MARK: Suggesged Frame
    func getSuggesedFrame(parentVC: UIViewController? = nil) -> CGRect {
        guard let p = parentVC else {
            return CGRect(x: 0, y: 0, width: getSuggestedWidth(), height: getSuggestedHeight())
        }
        return CGRect(x: p.view.center.x, y: p.view.center.y, width: getSuggestedWidth(parentVC: parentVC), height: getSuggestedHeight(parentVC: parentVC))
    }

    func getSuggestedWidth(parentVC: UIViewController? = nil) -> CGFloat {
        var layerWidth: CGFloat = viewWidth
        var layerHeight: CGFloat = viewHeight

        guard let p = parentVC else {
            if UIDevice.current.orientation.isLandscape {
                return viewHeight
            }
            return layerWidth
        }

        if UIDevice.current.orientation.isLandscape {
            layerHeight = p.view.frame.height - 20
            layerWidth = layerHeight / 1.4
        } else if UIDevice.current.orientation.isPortrait {
            layerWidth = p.view.frame.width - 20
            layerHeight = layerWidth * 1.4
        }

        return layerWidth
    }

    func getSuggestedHeight(parentVC: UIViewController? = nil) -> CGFloat {
        var layerWidth: CGFloat = viewWidth
        var layerHeight: CGFloat = viewHeight

        guard let p = parentVC else {
            if UIDevice.current.orientation.isLandscape {
                return viewWidth
            }
            return layerHeight
        }

        if UIDevice.current.orientation.isLandscape {
            layerHeight = p.view.frame.height - 20
            layerWidth = layerHeight / 1.4
        } else if UIDevice.current.orientation.isPortrait {
            layerWidth = p.view.frame.width - 20
            layerHeight = layerWidth * 1.4
        }

        return layerHeight
    }

    // MARK: Frame styling
    func addShadow(to layer: CALayer) {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red:0.14, green:0.25, blue:0.46, alpha:0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
    }
}
