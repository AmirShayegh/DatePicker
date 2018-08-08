//
//  DayCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-03.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    // MARK: Variables
    var parent: DaysCollectionViewCell?

    // MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func selectAction(_ sender: UIButton) {
        if let p = parent, let gp = p.parent, let day = self.label.text, let dayInt = Int(day) {
            gp.day = dayInt
            gp.reloadButton()
            p.collectionView.reloadData()
        }
//        select()
    }

    func setup(day: Int, selected: Bool, parent: DaysCollectionViewCell) {
        self.parent = parent
        self.label.text = "\(day)"

        self.view.layer.cornerRadius = 8
        if selected {
            select()
        } else {
            deselect()
        }
    }

    func select() {
        self.label.font = Fonts.heavy
        self.label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        self.view.backgroundColor = Colors.main
        self.label.textColor = Colors.selectedText
    }

    func deselect() {
        self.label.font = Fonts.regular
        self.label.backgroundColor = Colors.background
        self.view.backgroundColor = Colors.background
        self.label.textColor = Colors.main
    }
}
