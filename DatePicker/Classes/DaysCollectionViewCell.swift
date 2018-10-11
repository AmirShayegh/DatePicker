//
//  DaysCollectionViewCell.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-06.
//

import UIKit
import Extended

class DaysCollectionViewCell: UICollectionViewCell {

    let flipDuration: Double = 0.5
    // MARK: variables
    var parent: PickerViewController?
    var updating = false

    var mode: DatePickerMode = .Basic

    var selectedIndexPath: IndexPath?

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Setup
    func setup(mode: DatePickerMode, parent: PickerViewController) {
        self.mode = mode
        self.parent = parent
        initCollectionView()
        style()

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeUp.direction = .up
        self.collectionView.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeDown.direction = .down
        self.collectionView.addGestureRecognizer(swipeDown)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeLeft.direction = .left
        self.collectionView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_:)))
        swipeRight.direction = .right
        self.collectionView.addGestureRecognizer(swipeRight)
    }

    @objc func swiped(_ sender: UISwipeGestureRecognizer) {
        guard let p = self.parent else {return}

        p.calledFromSwipe = true
        switch sender.direction {
        case .left:
            flipRight()
            p.goToNextMonth()
        case .right:
            flipLeft()
            p.goToPrevMonth()
        case .up:
            flipRight()
            p.goToNextMonth()
        case .down:
            flipLeft()
            p.goToPrevMonth()
        default:
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + flipDuration) {
            p.calledFromSwipe = false
        }
    }

    func style() {
        self.collectionView.layer.backgroundColor = Colors.background.cgColor
    }

    func update() {

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func update(indexpath: IndexPath) {
        if let prev = selectedIndexPath {
            self.collectionView.reloadItems(at: [prev, indexpath])
        }
    }

    @objc func flipLeft() {
        guard let p = parent else {return}
        if p.month < 2 {return}
        let copy = FrameHelper.shared.getCloneView( of: self)
        p.view.addSubview(copy)

        self.isHidden = true
        let transitionOptions: UIView.AnimationOptions = [.showHideTransitionViews, DatePicker.leftTransitionAnimation]

        UIView.transition(with: copy, duration: flipDuration, options: transitionOptions, animations: {
            copy.removeFromSuperview()
        }, completion: { (done) in
            copy.removeFromSuperview()
        })

        UIView.transition(with: self, duration: flipDuration, options: transitionOptions, animations: {
            self.isHidden = false
        })
    }

    @objc func flipRight() {
        guard let p = parent else {return}
        if p.month > 11 {return}
        let copy = FrameHelper.shared.getCloneView( of: self)
        p.view.addSubview(copy)

        self.isHidden = true
        let transitionOptions: UIView.AnimationOptions = [ .showHideTransitionViews, DatePicker.rightTransitionAnimation]

        UIView.transition(with: copy, duration: flipDuration, options: transitionOptions, animations: {
            copy.isHidden = true
            copy.removeFromSuperview()
        }, completion: { (done) in
            copy.removeFromSuperview()
        })

        UIView.transition(with: self, duration: flipDuration, options: transitionOptions, animations: {
            self.isHidden = false
        })
    }


    var randomlyRealodedIndexes: [Int] = [Int]()

    func randomReload(done: @escaping()-> Void) {

            let numberOfElements = getNumberOfElements()
            if randomlyRealodedIndexes.count >= numberOfElements {
                randomlyRealodedIndexes.removeAll()
                return done()
            }
            var random = 0

            while randomlyRealodedIndexes.contains(random) {
//                random = Int.random(min: 0, max: (numberOfElements - 1))
                random = random + 1
            }
            randomlyRealodedIndexes.append(random)
            let indexPath = IndexPath(row: random, section: 0)
            if let cell = self.collectionView.cellForItem(at: indexPath) as? DayCollectionViewCell {
                cell.fadeOff()
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.007) {
            self.randomReload(done: done)

        }
    }

    func getNumberOfElements() -> Int {
        guard let p = self.parent else { return 0}
        switch self.mode {
        case .Basic:
            let rows = 7
            let colums = 7
            return (rows * colums)
        case .MinMax:
            let rows = 7
            let colums = 7
            return (rows * colums)
        case .Yearless:
            return p.daysInMonth()
        }
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
        return getNumberOfElements()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.mode {
        case .Basic:
            return getBasicModeCell(for: indexPath)
        case .MinMax:
            return getMinMaxModeCell(for: indexPath)
        case .Yearless:
            return getYearlessModeCell(for: indexPath)
        }
    }

    func getBasicModeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let p = self.parent else {
            let cell = getHeaderCell(indexPath: indexPath)
            cell.setup(day: "")
            return cell
        }
        let daysOfWeek = 7
        if indexPath.row < daysOfWeek {
            let cell = getHeaderCell(indexPath: indexPath)
            cell.setup(day: DatePickerHelper.shared.days()[indexPath.row])
            return cell
        } else if indexPath.row >= p.firstDayOfMonthIndex() && indexPath.row < p.lastDayOfMonthIndex() {
            let cell = getDayCell(indexPath: indexPath)
            let current = (indexPath.row - p.firstDayOfMonthIndex() + 1)
            // if day is currently selected, set selected to true
            if current == p.day {
                cell.setup(day: current, selected: true, indexPath: indexPath, parent: self)
                selectedIndexPath = indexPath
            } else {
                if let maxDate = p.maxDate, let minDate = p.minDate, let dateOfDay = DatePickerHelper.shared.dateFrom(day: current, month: p.month, year: p.year), dateOfDay > maxDate || dateOfDay < minDate {
                    cell.setup(day: current, disabled: true, indexPath: indexPath, parent: self)
                } else {
                    cell.setup(day: current, indexPath: indexPath, parent: self)
                }
            }
            return cell
        } else {
            let cell = getHeaderCell(indexPath: indexPath)
            cell.setup(day: "")
            return cell
        }
    }

    func getMinMaxModeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        return getBasicModeCell(for: indexPath)
    }

    func getYearlessModeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        var selected = false
        var disabled = false
        let currentDay = indexPath.row + 1
        if let p = self.parent {
            selected = p.day == (indexPath.row + 1)
            if p.month == p.minMonth && currentDay < p.minDay {
                disabled = true
            }
            if p.month == p.maxMonth && currentDay > p.maxDay {
                disabled = true
            }
        }
        let cell = getDayCell(indexPath: indexPath)
        cell.setup(day: currentDay, selected: selected, disabled: disabled, indexPath: indexPath, parent: self)
        if selected {
            self.selectedIndexPath = indexPath
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
