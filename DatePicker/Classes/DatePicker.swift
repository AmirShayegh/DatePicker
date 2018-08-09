//
//  FreshDate.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import Foundation

enum FreshDateMode {
    case Basic
    case MinMax
    case YearlessMinMax
}

public class DatePicker {

    // Bundle
    static var bundle: Bundle {
        let podBundle = Bundle(for: PickerViewController.self)

        if let bundleURL = podBundle.url(forResource: "DatePicker", withExtension: "bundle"), let b = Bundle(url: bundleURL) {
            return b
        } else {
            print("Fatal Error: Could not find bundle for FreshDate Frameworks")
            fatalError()
        }

    }

    // Picker view controller
    public lazy var vc: PickerViewController = {
        return UIStoryboard(name: "Picker", bundle: DatePicker.bundle).instantiateViewController(withIdentifier: "Picker") as! PickerViewController
    }()

    var parentVC: UIViewController?

    // MARK: Variables

    // default width
    // height is 1.4 times width
    var viewWidth: CGFloat = 200
    var viewHeight: CGFloat = (200 * 1.4)

    // default widht for popover
    // height is 1.4 times width
    var popoverWidth: CGFloat = (42 * 7)
    var popoverHeight: CGFloat = ((42 * 7) * 1.4)

    public init() {}

    // MARK: Setup

    // Basic setup, returns a date in the next 100 years from today
    public func setup(beginWith: Date? = nil, then: @escaping(_ date: Date) -> Void) {
        vc.mode = .Basic
        if let begin = beginWith {
             vc.set(date: begin)
        } else {
            vc.set(date: Date())
        }
        vc.callBack = then
    }

    // Setup with a min and max date
    public func setup(min:Date, max: Date, then: @escaping(_ date: Date) -> Void) {
        vc.mode = .MinMax
        vc.maxDate = max
        vc.minDate = min
        vc.set(date: min)
        vc.callBack = then
    }

    // Setup without years
    public func setup(minMonth: Int, minDay: Int, maxMonth: Int, maxDay: Int, then: @escaping(_ month: Int,_ day: Int) -> Void) {
        vc.mode = .YearlessMinMax
        vc.yearlessCallBack = then
    }

    // MARK: Presenataion

    // Display at the center of parent
    public func display(in parent: UIViewController) {
        self.parentVC = parent
        parent.addChildViewController(vc)
        FrameHelper.shared.sizeAndCenter(view: vc.view, in: parent)
        FrameHelper.shared.addShadow(to: vc.view.layer)
        parent.view.addSubview(vc.view)
        vc.didMove(toParentViewController: parent)
    }

    // Display as popover on button
    public func displayPopOver(on: UIButton, in parent: UIViewController, width: CGFloat? = nil, arrowColor: UIColor? = nil) {
        if let w = width {
            self.popoverWidth = w
            self.popoverHeight = w * 1.4
        }

        parent.view.endEditing(true)
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
        FrameHelper.shared.addShadow(to: vc.view.layer)
        let popover = vc.popoverPresentationController
        popover?.backgroundColor = arrowColor ?? Colors.background
        popover?.permittedArrowDirections = .any
        popover?.sourceView = on
        popover?.sourceRect = CGRect(x: on.bounds.midX, y: on.bounds.midY, width: 0, height: 0)
        parent.present(vc, animated: true, completion: nil)
    }

    // Manually change width and height
    public func set(width: CGFloat, height: CGFloat) {
        self.viewWidth = width
        self.viewHeight = height
        self.popoverWidth = width
        self.popoverHeight = height
    }

    func getContainer() -> UIView {
        // Create and style layer
        let layer = UIView(frame: FrameHelper.shared.getSuggesedFrame(parentVC: parentVC))
        layer.layer.cornerRadius = 5
        layer.backgroundColor = Colors.background
        // Add Shadow
        FrameHelper.shared.addShadow(to: layer.layer)
        // Position
        FrameHelper.shared.centerViewInParent(view: layer)
        // Tag
        layer.tag = 1
        return layer
    }
}
