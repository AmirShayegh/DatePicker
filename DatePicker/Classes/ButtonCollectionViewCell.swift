//
//  ButtonCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-07.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    var callBack: (() -> Void)?

    @IBOutlet weak var button: UIButton!

    @IBAction func clicked(_ sender: UIButton) {
        if self.callBack != nil {
            return self.callBack!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setFrom(date: Date) {
        self.button.setTitle(" Select \(date.string())", for: .normal)
    }

    func setup(date: Date, clicked: @escaping() -> Void) {
        self.callBack = clicked
        self.button.setTitle(date.string(), for: .normal)
        style()
    }

    func style() {
//        styleButton(button: button, bg: Colors.main, borderColor: Colors.main.cgColor, titleColor: Colors.selectedText)
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
