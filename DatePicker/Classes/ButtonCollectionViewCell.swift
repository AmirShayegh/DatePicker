//
//  ButtonCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-07.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    // MARK: Optionals
    var callBack: (() -> Void)?

    // MARK: Outlets
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var divider: UIView!

    // MARK: Outlet Actions
    @IBAction func clicked(_ sender: UIButton) {
        if self.callBack != nil {
            return self.callBack!()
        }
    }

    // MARK: Setup
    /*
     - Parameter date: date displayed on button
     - Parameter clicked: call back when button is clicked
     */
    func setup(date: Date, clicked: @escaping() -> Void) {
        self.callBack = clicked
        style()
    }

    func style() {
        divider.backgroundColor = Colors.main
        self.button.setTitleColor(Colors.main, for: .normal)
        button.titleLabel?.font = Fonts.regular
    }

    func styleButton(button: UIButton, bg: UIColor, borderColor: CGColor, titleColor: UIColor) {
        button.layer.cornerRadius = 8
        button.backgroundColor = bg
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor
        button.setTitleColor(titleColor, for: .normal)
    }

}
