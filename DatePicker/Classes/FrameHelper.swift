//
//  FrameHelper.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-07.
//

import Foundation

class FrameHelper {
    static let shared = FrameHelper()

    static var ratio: CGFloat = 1.5
    var parent: UIViewController?

    var viewWidth: CGFloat = 200
    var viewHeight: CGFloat = (200 * ratio)

    var yearlessDayColumns = 7


    private init() {}

    func getYearlessPopOverSize(for width: CGFloat) -> CGSize {
        let daysSize = getYearlessDaysCellSize(for: width)
        let dayHeight = getDayCellHeight(width: width, columns: yearlessDayColumns)
        return CGSize(width: width, height: (daysSize.height + dayHeight))
    }

    func getYearlessDaysCellSize(for width: CGFloat) -> CGSize {
        let dayHeight = getDayCellHeight(width: width, columns: yearlessDayColumns)
        // 2 rows less required
        return CGSize(width: width, height: width - (dayHeight * 2))
    }

    func getDayCellHeight(width: CGFloat, columns: Int) -> CGFloat {
        return width / CGFloat(columns)
    }

    func getCloneView(of uiView: UIView) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: uiView.frame.width, height: uiView.frame.height))
        let imageView = UIImageView(image: uiView.toImage())
        imageView.frame =  CGRect(x: 0, y: 0, width: uiView.frame.width, height: uiView.frame.height)


        view.center.y = uiView.center.y
        view.center.x = uiView.center.x
        view.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.9)
        view.alpha = 1
        view.tag = 99
        imageView.frame = view.frame
        view.addSubview(imageView)
        return view
    }

    // MARK: Positioning
    func centerViewInParent(view: UIView, in parentVC: UIViewController? = nil) {
        guard let p = parentVC else {return}
        view.center.x = p.view.center.x
        view.center.y = p.view.center.y
        view.centerXAnchor.constraint(equalTo: p.view.centerXAnchor)
        view.centerYAnchor.constraint(equalTo: p.view.centerYAnchor)
    }

    func positionCenter(view:UIView, in parentVC: UIViewController, yearless: Bool) {
        view.frame = getSuggesedFrame(padding: 20, for: parentVC.view.frame.size, yearless: yearless)
        view.center.x = parentVC.view.center.x
        view.center.y = parentVC.view.center.y
        view.centerXAnchor.constraint(equalTo: parentVC.view.centerXAnchor)
        view.centerYAnchor.constraint(equalTo: parentVC.view.centerYAnchor)
    }

    func positionBottom(view: UIView, in parentVC: UIViewController, size: CGSize? = nil, yearless: Bool) {
        let parentHeight = parentVC.view.frame.size.height
        var h = getSuggestedHeight(for: parentVC.view.frame.size)
        let w = getSuggestedWidth(for: parentVC.view.frame.size)
        if yearless {
            h = getYearlessDaysCellSize(for: w).height + (getDayCellHeight(width: w, columns: yearlessDayColumns) * 2.5)
        }
        view.frame = CGRect(x: 0, y: parentHeight - h, width: w, height: h)
        view.center.x = parentVC.view.center.x
        view.centerXAnchor.constraint(equalTo: parentVC.view.centerXAnchor)
    }

    func positionBottomPreAnimation(view:UIView, in parentVC: UIViewController, yearless: Bool) {
        let parentHeight = parentVC.view.frame.size.height
        var h = getSuggestedHeight(for: parentVC.view.frame.size)
        let w = getSuggestedWidth(for: parentVC.view.frame.size)
        if yearless {
            h = getYearlessDaysCellSize(for: w).height + (getDayCellHeight(width: w, columns: yearlessDayColumns) * 2.5)
        }

        view.frame = CGRect(x: 0, y: parentHeight, width: w, height: h)
        view.center.x = parentVC.view.center.x
        view.centerXAnchor.constraint(equalTo: parentVC.view.centerXAnchor)
    }


    // MARK: Suggesged Frame
    func getSuggesedFrame(padding: CGFloat? = 0, for size: CGSize? = nil, yearless: Bool) -> CGRect {
        let w = getSuggestedWidth(padding: padding, for: size)
        var h = getSuggestedHeight(padding: padding, for: size)
        if yearless {
            h = getYearlessDaysCellSize(for: w).height + (getDayCellHeight(width: w, columns: yearlessDayColumns) * 2.5)
        }
        return CGRect(x: 0, y: 0, width: w, height: h)
    }

    func getSuggestedWidth(padding: CGFloat? = 0, for size: CGSize? = nil) -> CGFloat {
        var layerWidth: CGFloat = viewWidth
        var layerHeight: CGFloat = viewHeight

        guard let s = size else {
            if UIDevice.current.orientation.isLandscape {
                return viewHeight
            }
            return layerWidth
        }

        if s.width > s.height {
            // landscape
            layerHeight = s.height - padding!
            layerWidth = layerHeight / FrameHelper.ratio

        } else {
            // portrait
            layerWidth = s.width - padding!
            layerHeight = layerWidth * FrameHelper.ratio
        }

        return layerWidth
    }

    func getSuggestedHeight(padding: CGFloat? = 0, for size: CGSize? = nil) -> CGFloat {
        var layerWidth: CGFloat = viewWidth
        var layerHeight: CGFloat = viewHeight

        guard let s = size else {
            if UIDevice.current.orientation.isLandscape {
                return viewWidth
            }
            return layerHeight
        }

        if s.width > s.height {
            // landscape
            layerHeight = s.height - padding!
            layerWidth = layerHeight / FrameHelper.ratio

        } else {
            // portrait
            layerWidth = s.width - padding!
            layerHeight = layerWidth * FrameHelper.ratio
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
