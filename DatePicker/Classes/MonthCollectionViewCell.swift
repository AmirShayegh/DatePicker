//
//  MonthCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(month: String, parent: MonthsCollectionViewCell) {
        self.label.text = month
        if let gp = parent.parent {
            if FDHelper.shared.month(name: month) == gp.month {
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
