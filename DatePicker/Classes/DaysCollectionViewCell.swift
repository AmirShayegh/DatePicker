//
//  DaysCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class DaysCollectionViewCell: UICollectionViewCell {

    // MARK: variables
    var parent: PickerViewController?

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Setup
    func setup(parent: PickerViewController) {
        self.parent = parent
        initCollectionView()
        style()
    }

    func style() {
        self.collectionView.layer.backgroundColor = Colors.background.cgColor
    }

}

// MARK: CollectionView
extension DaysCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func initCollectionView() {
        registerCell(name: "DayCollectionViewCell")
        registerCell(name: "DayHeaderCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = cellSize()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func cellSize() -> CGSize {
        let w = (self.collectionView.frame.width / 7)
        return CGSize(width: w, height: w)
    }

    func registerCell(name: String) {
        collectionView.register(UINib(nibName: name, bundle: DatePicker.bundle), forCellWithReuseIdentifier: name)
    }

    func getHeaderCell(indexPath: IndexPath) -> DayHeaderCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "DayHeaderCollectionViewCell", for: indexPath) as! DayHeaderCollectionViewCell
    }

    func getDayCell(indexPath: IndexPath) -> DayCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as! DayCollectionViewCell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rows = 7
        let colums = 7
        return (rows * colums)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let p = self.parent else {
            let cell = getHeaderCell(indexPath: indexPath)
            cell.setup(day: "")
            return cell
        }
        let daysOfWeek = 7
        if indexPath.row < daysOfWeek {
            let cell = getHeaderCell(indexPath: indexPath)
            cell.setup(day: FDHelper.shared.days()[indexPath.row])
            return cell
        } else if indexPath.row >= p.firstDayOfMonthIndex() && indexPath.row < p.lastDayOfMonthIndex() {
            let cell = getDayCell(indexPath: indexPath)
            let current = (indexPath.row - p.firstDayOfMonthIndex() + 1)
            // if day is currently selected, set selected to true
            if (indexPath.row - p.firstDayOfMonthIndex() + 1) == p.day {
                cell.setup(day: current, selected: true, parent: self)
            } else {
                if let maxDate = p.maxDate, let minDate = p.minDate, let dateOfDay = FDHelper.shared.dateFrom(day: current, month: p.month, year: p.year), dateOfDay > maxDate || dateOfDay < minDate {
                    cell.setup(day: current, disabled: true, parent: self)
                } else {
                    cell.setup(day: current, parent: self)
                }
            }
            return cell
        } else {
            let cell = getHeaderCell(indexPath: indexPath)
            cell.setup(day: "")
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
