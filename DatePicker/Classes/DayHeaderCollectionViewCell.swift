//
//  DayHeaderCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class DayHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(day: String) {
        self.dayLabel.text = day
        style()
    }

    func style() {
        self.backgroundColor = DatePickerColors.background
        self.dayLabel.textColor = DatePickerColors.main
        self.dayLabel.font = Fonts.medium
    }

}
