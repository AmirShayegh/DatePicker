//
//  DatePickerPresentationController.swift
//  DatePicker
//
//  Centers the picker over a dimmed, tap-to-cancel backdrop
//  (DatePickerStyle.center).
//

import UIKit

class DatePickerPresentationController: UIPresentationController {

    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = DatePickerColors.backdrop
        view.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(backdropTapped))
        view.addGestureRecognizer(tap)
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let yearless = (presentedViewController as? PickerViewController)?.mode == .Yearless
        var frame = FrameHelper.shared.getSuggesedFrame(padding: 40, for: container.bounds.size, yearless: yearless)
        frame.origin.x = (container.bounds.width - frame.width) / 2
        frame.origin.y = (container.bounds.height - frame.height) / 2
        return frame
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let container = containerView else { return }
        dimmingView.frame = container.bounds
        container.insertSubview(dimmingView, at: 0)

        presentedView?.layer.cornerRadius = 16
        presentedView?.clipsToBounds = true

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            })
        } else {
            dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            })
        } else {
            dimmingView.alpha = 0
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let container = containerView else { return }
        dimmingView.frame = container.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc private func backdropTapped() {
        (presentedViewController as? PickerViewController)?.cancelFromBackdrop()
    }
}
