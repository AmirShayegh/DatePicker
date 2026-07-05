//
//  FreshDate.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import UIKit

enum DatePickerMode {
    case Basic
    case MinMax
    case Yearless
}

/// Presentation styles for `DatePicker.show(in:style:sourceView:)`.
public enum DatePickerStyle {
    /// Popover on iPad when a sourceView is provided, sheet otherwise.
    case automatic
    /// Bottom sheet sized to the picker.
    case sheet
    /// Popover anchored to sourceView. Falls back to a sheet when no
    /// sourceView is provided.
    case popover
    /// Centered card over a dimmed backdrop.
    case center
}

public class DatePicker {

    public static var leftTransitionAnimation: UIView.AnimationOptions = .transitionFlipFromLeft
    public static var rightTransitionAnimation: UIView.AnimationOptions = .transitionFlipFromRight

    // Bundle containing the library's storyboard and xibs,
    // resolved for both SPM and CocoaPods installations.
    static var bundle: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        let frameworkBundle = Bundle(for: PickerViewController.self)
        if let bundleURL = frameworkBundle.url(forResource: "DatePicker", withExtension: "bundle"),
           let resourceBundle = Bundle(url: bundleURL) {
            return resourceBundle
        }
        return frameworkBundle
        #endif
    }

    // Picker view controller
    public lazy var vc: PickerViewController = {
        return UIStoryboard(name: "Picker", bundle: DatePicker.bundle).instantiateViewController(withIdentifier: "Picker") as! PickerViewController
    }()

    // MARK: Optionals
    var parentVC: UIViewController?

    // MARK: Variables

    // default width for popover
    var popoverWidth: CGFloat = (48 * 7)

    /// Title of the confirm button. Set this to localize or
    /// customize the default "Select".
    public var selectButtonTitle: String = "Select" {
        didSet {
            vc.selectButtonTitle = selectButtonTitle
        }
    }

    /// Optional custom font for the confirm button.
    public var selectButtonFont: UIFont? {
        didSet {
            vc.selectButtonFont = selectButtonFont
        }
    }

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
        // Use a leap year for the default max day so an unspecified
        // February bound allows the 29th (yearless has no real year).
        vc.maxDay = maxDay ?? DatePickerHelper.shared.daysIn(month: vc.maxMonth, year: 2020)
        vc.day = minDay ?? 1
        vc.month = minMonth ?? 1
        vc.mode = .Yearless
        vc.yearlessCallBack = selected
    }

    // MARK: Presentation

    /// Show the date picker in the given view controller:
    /// a popover on iPad when popOverItem is provided, a bottom sheet
    /// otherwise.
    /// - Parameters:
    ///   - parent: UIViewController to present on
    ///   - on: UIView to anchor a popover to (for iPad)
    public func show(in parent: UIViewController, on popOverItem: UIView? = nil) {
        show(in: parent, style: .automatic, sourceView: popOverItem)
    }

    /// Show the date picker with an explicit presentation style.
    /// - Parameters:
    ///   - parent: UIViewController to present on
    ///   - style: how the picker is presented
    ///   - sourceView: anchor view, required for the popover style
    public func show(in parent: UIViewController, style: DatePickerStyle, sourceView: UIView? = nil) {
        // dismiss keyboards
        parent.view.endEditing(true)
        self.parentVC = parent
        switch style {
        case .automatic:
            if UIDevice.current.userInterfaceIdiom == .pad, let anchor = sourceView {
                presentPopover(on: anchor, in: parent)
            } else {
                presentSheet(in: parent)
            }
        case .sheet:
            presentSheet(in: parent)
        case .popover:
            if let anchor = sourceView {
                presentPopover(on: anchor, in: parent)
            } else {
                presentSheet(in: parent)
            }
        case .center:
            presentCenter(in: parent)
        }
    }

    @available(*, deprecated, message: "Use show(in:style:sourceView:) instead")
    public func display(in parent: UIViewController) {
        show(in: parent, style: .sheet)
    }

    @available(*, deprecated, message: "Use show(in:style:sourceView:) instead")
    public func displayPopOver(on: UIView, in parent: UIViewController, width: CGFloat? = nil, completion: @escaping ()-> Void) {
        if let w = width {
            self.popoverWidth = w
        }
        show(in: parent, style: .popover, sourceView: on)
        completion()
    }

    private func presentSheet(in parent: UIViewController) {
        vc.displayMode = .Bottom
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let yearless = vc.mode == .Yearless
                sheet.detents = [.custom { [weak parent] context in
                    let width = parent?.view.bounds.width ?? (context.maximumDetentValue / FrameHelper.ratio)
                    let height = FrameHelper.shared.preferredPickerSize(width: width, yearless: yearless).height
                    return min(height, context.maximumDetentValue)
                }]
            } else {
                // Custom detents require iOS 16; fall back to the
                // system large detent on iOS 15.
                sheet.detents = [.large()]
            }
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        vc.presentationController?.delegate = vc
        parent.present(vc, animated: true)
    }

    private func presentPopover(on anchor: UIView, in parent: UIViewController) {
        vc.displayMode = .PopOver
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = FrameHelper.shared.preferredPickerSize(width: popoverWidth, yearless: vc.mode == .Yearless)
        FrameHelper.shared.addShadow(to: vc.view.layer)
        guard let popover = vc.popoverPresentationController else { return }
        popover.backgroundColor = DatePickerColors.background
        popover.permittedArrowDirections = .any
        popover.sourceView = anchor
        popover.sourceRect = CGRect(x: anchor.bounds.midX, y: anchor.bounds.midY, width: 0, height: 0)
        popover.delegate = vc
        parent.present(vc, animated: true)
    }

    private func presentCenter(in parent: UIViewController) {
        vc.displayMode = .Center
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        parent.present(vc, animated: true)
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
