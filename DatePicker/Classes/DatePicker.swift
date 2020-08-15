//
//  FreshDate.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import Foundation

enum DatePickerMode {
    case Basic
    case MinMax
    case Yearless
}

public class DatePicker {

    public static var leftTransitionAnimation: UIView.AnimationOptions = .transitionFlipFromLeft
    public static var rightTransitionAnimation: UIView.AnimationOptions = .transitionFlipFromRight

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

    // MARK: Optionals
    var parentVC: UIViewController?

    // MARK: Variables

    // default width for popover
    // height is 1.3 times width
    var popoverWidth: CGFloat = (48 * 7)
    var popoverHeight: CGFloat = ((48 * 7) * 1.3)

    public init() {}

    // MARK: Setup

    // Basic setup, returns a date in the next 100 years from today
    public func setup(beginWith: Date? = nil, selected: @escaping(_ selected: Bool, _ date: Date?) -> Void) {
        vc.mode = .Basic
        if let begin = beginWith {
            vc.set(date: begin)
        } else {
            vc.set(date: Date())
        }
        vc.callBack = selected
    }

    // Setup with a min and max date
    public func setup(beginWith: Date? = nil, min:Date, max: Date, selected: @escaping(_ selected: Bool, _ date: Date?) -> Void) {
        vc.mode = .Basic
        if let begin = beginWith {
            vc.set(date: begin)
        } else {
            vc.set(date: min)
        }
        vc.mode = .MinMax
        vc.maxDate = max
        vc.minDate = min
        vc.callBack = selected
    }

    // Setup without years
    public func setupYearless(minMonth: Int? = nil, minDay: Int? = nil, maxMonth: Int? = nil, maxDay: Int? = nil, selected: @escaping(_ selected: Bool, _ month: Int?,_ day: Int?) -> Void) {
        vc.minDay = minDay ?? 1
        vc.minMonth = minMonth ?? 1
        vc.maxMonth = maxMonth ?? 12
        vc.maxDay = maxDay ?? DatePickerHelper.shared.daysIn(month: vc.maxMonth, year: vc.year)
        vc.day = minDay ?? 1
        vc.month = minMonth ?? 1
        vc.mode = .Yearless
        vc.yearlessCallBack = selected
    }

    // MARK: Presenataion

    // Display at the bottom of parent
    @available(*, deprecated, message: "Use show() instead")
    public func display(in parent: UIViewController) {
       display_(in: parent)
    }
    
    private func display_(in parent: UIViewController) {
        self.parentVC = parent
        vc.displayMode = .Bottom
        vc.display(on: parent)
    }

    // Display as popover on button
    @available(*, deprecated, message: "Use show() instead")
    public func displayPopOver(on: UIView, in parent: UIViewController, width: CGFloat? = nil, completion: @escaping ()-> Void) {
        display_PopOver(on: on, in: parent, width: width, completion: completion)
    }
    
    private func display_PopOver(on: UIView, in parent: UIViewController, width: CGFloat? = nil, completion: @escaping ()-> Void) {
        // dismiss keyboards
        parent.view.endEditing(true)

        // set mode
        vc.displayMode = .PopOver

        // size
        if let w = width {
            self.popoverWidth = w
            self.popoverHeight = w * FrameHelper.ratio
        }

        var frameSize = CGSize(width: popoverWidth, height: popoverHeight)

        if vc.mode == .Yearless {
            frameSize = FrameHelper.shared.getYearlessPopOverSize(for: popoverWidth)
        }

        // style
        FrameHelper.shared.addShadow(to: vc.view.layer)

        // popover
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = frameSize
        guard let popover = vc.popoverPresentationController else {return}
        popover.backgroundColor = DatePickerColors.background
        popover.permittedArrowDirections = .any
        popover.sourceView = on
        popover.sourceRect = CGRect(x: on.bounds.midX, y: on.bounds.midY, width: 0, height: 0)
        parent.present(vc, animated: true, completion: nil)
    }

    // change colors
    
    public func colors(mainLight: UIColor, backgroundLight: UIColor, inactiveLight: UIColor, mainDark: UIColor, backgroundDark: UIColor, inactiveDark: UIColor) {
        DatePickerColors.mainLight = mainLight
        DatePickerColors.backgroundLight = backgroundLight
        DatePickerColors.inactiveTextLight = inactiveLight
        DatePickerColors.mainDark = mainDark
        DatePickerColors.backgroundDark = backgroundDark
        DatePickerColors.inactiveTextDark = inactiveDark
    }
    
    public func setColors(main: UIColor, background: UIColor, inactive: UIColor) {
        DatePickerColors.mainLight = main
        DatePickerColors.backgroundLight = background
        DatePickerColors.inactiveTextLight = inactive
        DatePickerColors.mainDark = main
        DatePickerColors.backgroundDark = background
        DatePickerColors.inactiveTextDark = inactive
    }
}

extension DatePicker {
    
    
    /// Show date picker in the indicated UIViewController
    /// For iPad suppoet:
    /// Specify a UIView in the popOverItem Parameter for displaying DatePicker as a popover on the UIView
    /// - Parameters:
    ///   - parent: UIViewController to present on
    ///   - on: UIView to show popoever on (for iPad)
    public func show(in parent: UIViewController, on popOverItem: UIView? = nil) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let view = popOverItem else {
                print("***************")
                print("** DatePicker config error: Specify popOverItem for displaying on iPad!")
                print("***************")
                return
            }
            display_PopOver(on: view, in: parent, completion: {})
        } else {
            display_(in: parent)
        }
    }
}
