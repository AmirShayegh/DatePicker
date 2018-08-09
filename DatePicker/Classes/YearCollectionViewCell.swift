//
//  YearCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {
    // MARK: Optionals
    var parent: YearsCollectionViewCell?

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    // MARK: Outlet Actions
    @IBAction func butonClicked(_ sender: UIButton) {
        guard let p = parent, let gp = p.parent, let y = label.text, let year = Int(y) else {return}
        gp.changeYear(to: year)
    }

    // MARK: Setup
    func setup(year: Int, parent: YearsCollectionViewCell) {
        self.parent = parent
        if year != 0 {
            self.label.text = "\(year)"
        } else {
            self.label.text = ""
        }
        if let gp = parent.parent {
            if year == gp.year {
                select()
                return
            }
        }

        deselect()
    }

    func select() {
        UIView.animate(withDuration: 0.3, animations: {
            self.label.font = Fonts.heavy
            self.label.textColor = Colors.main
        })
    }

    func deselect() {
        UIView.animate(withDuration: 0.3, animations: {
            self.label.font = Fonts.regular
            self.label.textColor = Colors.inactiveText
        })
    }
}
