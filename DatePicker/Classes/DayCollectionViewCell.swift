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
    @IBOutlet weak var button: UIButton!

    let selection = UISelectionFeedbackGenerator()

    var indexPath: IndexPath?

    // MARK: Outlet Actions
    @IBAction func selectAction(_ sender: UIButton) {
        if let p = parent, let gp = p.parent, let day = self.label.text, let dayInt = Int(day) {
            gp.day = dayInt
            selection.selectionChanged()
            gp.reloadButton()
//            p.update()
            if let i = indexPath {
                if let pi = p.selectedIndexPath, pi == i {
                    return
                }
                p.update(indexpath: i)
            }
        }
    }

    // MARK: Setup
    /*
     - Parameter day: day number
     - Parameter selected: is day selected? / currently day?
     - Parameter disabled: is day out of not selectable?
     - Parameter parent: parent cell - DaysCollectionViewCell
     */
    func setup(day: Int, selected: Bool? = false, disabled: Bool? = false, indexPath: IndexPath, parent: DaysCollectionViewCell) {
        self.alpha = 0
        self.parent = parent
        if day == -1 {
            self.label.text = ""
        } else {
            self.label.text = "\(day)"
        }
        self.view.layer.cornerRadius = 8
        self.indexPath = indexPath
        if let s = selected, s {
            select()
        } else {
            deselect()
        }

        if let d = disabled, d {
            self.label.textColor = DatePickerColors.inactiveText
            self.button.isUserInteractionEnabled = false
        } else {
            self.button.isUserInteractionEnabled = true
        }

        self.alpha = 1
        backgroundColor = .clear
        clipsToBounds = true
    }

    func select() {
        
        self.label.font = Fonts.heavy
        self.label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        self.view.backgroundColor = DatePickerColors.main
        self.label.textColor = DatePickerColors.background
    }

    func deselect() {
        self.label.font = Fonts.regular
        self.label.backgroundColor = DatePickerColors.background
        self.view.backgroundColor = .clear
        self.label.textColor = DatePickerColors.main
    }

    func fadeOff() {
        self.alpha = 0
    }
}
