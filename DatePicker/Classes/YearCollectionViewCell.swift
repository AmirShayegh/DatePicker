//
//  YearCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(year: Int, parent: YearsCollectionViewCell) {
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
