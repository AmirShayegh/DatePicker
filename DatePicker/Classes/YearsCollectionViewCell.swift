//
//  YearsCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class YearsCollectionViewCell: UICollectionViewCell {

    // MARK: Constants
    let paddingCells = 4
    let itemsPerPage = 5
    let selection = UISelectionFeedbackGenerator()

    // MARK: Optionals
    var parent: PickerViewController?
    var currentCenterCellIndexPath: IndexPath?

    // MARK: Variables
    var items: [Int] = [Int]()
    var seleced: [IndexPath] = [IndexPath]()

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomDivider: UIView!
    @IBOutlet weak var middleIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(items: [Int], parent: PickerViewController) {
        self.items = items
        self.parent = parent
        initCollectionView()
        style()
    }

    func style() {
        self.middleIndicator.backgroundColor = Colors.inactiveText
        middleIndicator.alpha = 0
        self.bottomDivider.backgroundColor = Colors.inactiveText
        self.collectionView.backgroundColor = Colors.background
    }

}

// MARK: CollectionView
extension YearsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: CollectionView Setup
    func initCollectionView() {
        registerCell(name: "YearCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = cellSize()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: CollectionView Events
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            scrollToYear(at: centerCellIndexPath)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            scrollToYear(at: centerCellIndexPath)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        selection.selectionChanged()
        if let p = parent {
            p.YearOrMonthChanged()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            if let current = self.currentCenterCellIndexPath, current != centerCellIndexPath {
                selection.selectionChanged()
            }
            self.currentCenterCellIndexPath = centerCellIndexPath
            highlightCell(at: centerCellIndexPath)
        }
    }

    func select(year: Int) {
        guard let indexPathRow = items.index(of: year)  else { return }
        let indexPath: IndexPath = [0,(indexPathRow + paddingCells / 2)]
        scrollToYear(at: indexPath)
    }

    func scrollToYear(at: IndexPath) {
        if at.row < paddingCells - 1 {
            let indexPath: IndexPath = [0, (paddingCells/2)]
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else if at.row > (items.count - 1) + (paddingCells/2) {
            let indexPath: IndexPath = [0, paddingCells/2 + (items.count - 1)]
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            self.collectionView.scrollToItem(at: at, at: .centeredHorizontally, animated: true)
        }
    }

    func highlightCell(at: IndexPath) {
        seleced.append(at)
        let visibleRows = collectionView.indexPathsForVisibleItems
        for item in visibleRows {
            let cell = collectionView.cellForItem(at: item) as! YearCollectionViewCell
            cell.deselect()
        }
        if visibleRows.contains(at) {
            let cell = collectionView.cellForItem(at: at) as! YearCollectionViewCell
            cell.select()
            if let p = parent, let text = cell.label.text, let number = Int(text) {
                p.year = number
            }
        }
    }

    private func indexOfMajorCell() -> Int {
        let itemWidth = cellWidth()
        let proportionalOffset = collectionView.collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(items.count - 1, index))
        return safeIndex
    }

    // MARK: CollectionView Cell Setup
    func cellWidth() -> CGFloat {
        return 90
    }

    func cellSize() -> CGSize {
        let w = cellWidth()
        return CGSize(width: w, height: self.collectionView.frame.height)
    }

    func registerCell(name: String) {
        collectionView.register(UINib(nibName: name, bundle: DatePicker.bundle), forCellWithReuseIdentifier: name)
    }
    func getYearsCell(indexPath: IndexPath) -> YearCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "YearCollectionViewCell", for: indexPath) as! YearCollectionViewCell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count + paddingCells
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.row < paddingCells / 2 {
            let cell = getYearsCell(indexPath: indexPath)
            cell.setup(year: 0, parent: self)
            return cell
        } else if indexPath.row - paddingCells / 2 < items.count {
            let cell = getYearsCell(indexPath: indexPath)
            cell.setup(year: items[indexPath.row - paddingCells / 2], parent: self)
            return cell
        } else {
            let cell = getYearsCell(indexPath: indexPath)
            cell.setup(year: 0, parent: self)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
