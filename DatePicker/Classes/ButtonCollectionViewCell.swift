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
        self.button.setTitle(date.string(), for: .normal)
        style()
    }

    func setFrom(date: Date) {
        self.button.setTitle(" Select \(date.string())", for: .normal)
    }

    func style() {
        styleButton(button: button, bg: Colors.background, borderColor: Colors.background.cgColor, titleColor: Colors.main)
        button.titleLabel?.font = Fonts.heavy

    }

    func styleButton(button: UIButton, bg: UIColor, borderColor: CGColor, titleColor: UIColor) {
        button.layer.cornerRadius = 0
        button.backgroundColor = bg
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor
        button.setTitleColor(titleColor, for: .normal)
    }

}
