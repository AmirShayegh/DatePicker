//
//  MonthCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {

    // MARK: Optionals
    var parent: MonthsCollectionViewCell?

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    @IBAction func butonClicked(_ sender: UIButton) {
        guard let p = parent, let gp = p.parent, let month = label.text else {return}
        gp.changeMonth(to: month)
    }

    // MARK: Setup
    func setup(month: String, parent: MonthsCollectionViewCell) {
        self.label.text = month
        self.parent = parent
        if let gp = parent.parent {
            if DatePickerHelper.shared.month(name: month) == gp.month {
                select()
                return
            }
        }
        
        deselect()
    }

    func select() {
        self.label.font = Fonts.heavy
        self.label.textColor = DatePickerColors.main
    }

    func deselect() {
        self.label.font = Fonts.regular
        self.label.textColor = DatePickerColors.inactiveText
    }

}
