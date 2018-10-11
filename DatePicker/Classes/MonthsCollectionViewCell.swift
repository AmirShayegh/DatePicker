//
//  MonthsCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit

class MonthsCollectionViewCell: UICollectionViewCell {

    let paddingCells = 4
    let itemsPerPage = 5
    let selection = UISelectionFeedbackGenerator()

    var parent: PickerViewController?
    var items: [String] = [String]()
    var currentCenterCellIndexPath: IndexPath?

    var seleced: [IndexPath] = [IndexPath]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomDivider: UIView!
    @IBOutlet weak var middleIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(items: [String], parent: PickerViewController) {
        self.parent = parent
        self.items = items
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
extension MonthsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func initCollectionView() {
        registerCell(name: "MonthCollectionViewCell")
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            scrollToMonth(at: centerCellIndexPath)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            scrollToMonth(at: centerCellIndexPath)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
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

    func scrollToMonth(at: IndexPath) {
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

    func select(month: String) {
        guard let indexPathRow = items.index(of: month)  else { return }
        let indexPath: IndexPath = [0,(indexPathRow + paddingCells / 2)]
        scrollToMonth(at: indexPath)
    }

    func highlightCell(at: IndexPath) {
        seleced.append(at)
        let visibleRows = collectionView.indexPathsForVisibleItems
        for item in visibleRows {
            let cell = collectionView.cellForItem(at: item) as! MonthCollectionViewCell
            cell.deselect()
        }
        if visibleRows.contains(at) {
            let cell = collectionView.cellForItem(at: at) as! MonthCollectionViewCell
            cell.select()
            if let p = parent, let text = cell.label.text {
                p.month = DatePickerHelper.shared.month(name: text)
            }
        }
    }

    func cellSize() -> CGSize {
        let w: CGFloat = 90
        return CGSize(width: w, height: self.collectionView.frame.height)
    }

    func registerCell(name: String) {
        collectionView.register(UINib(nibName: name, bundle: DatePicker.bundle), forCellWithReuseIdentifier: name)
    }

    func getMonthsCell(indexPath: IndexPath) -> MonthCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (items.count + paddingCells)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < paddingCells / 2 {
            let cell = getMonthsCell(indexPath: indexPath)
            cell.setup(month: "", parent: self)
            return cell
        } else if indexPath.row - paddingCells / 2 < items.count {
            let cell = getMonthsCell(indexPath: indexPath)
            cell.setup(month: items[indexPath.row - paddingCells / 2], parent: self)
            return cell
        } else {
            let cell = getMonthsCell(indexPath: indexPath)
            cell.setup(month: "", parent: self)
            return cell
        }

    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
