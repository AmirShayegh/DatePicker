//
//  PickerViewController.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import UIKit

public class PickerViewController: UIViewController {

    // MARK: Optionals
    var callBack: ((_ date: Date)-> Void)?
    var yearlessCallBack: ((_ month: Int,_ day: Int)-> Void)?

    var monthsIndexPath: IndexPath?
    var yearsIndexPath: IndexPath?
    var daysIndexPath: IndexPath?
    var buttonIndexPath: IndexPath?

    // MARK: Variables
    var mode: FreshDateMode = .Basic
    var day: Int = 18
    var month: Int = 9
    var year: Int = 2018

    var minDate: Date?
    var maxDate: Date?

    var minMonth: Int = 0
    var minDay: Int = 0
    var maxMonth: Int = 0
    var maxDay: Int = 0

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        style()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func changeDay(to: Int) {
        self.day = to
        reloadDays()
    }

    func reloadButton() {
        validate()
        guard let indexpath = buttonIndexPath else {return}
        if collectionView.indexPathsForVisibleItems.contains(indexpath) {
            let cell = collectionView.cellForItem(at: indexpath) as! ButtonCollectionViewCell
            cell.setFrom(date: FDHelper.shared.dateFrom(day: day, month: month, year: year)!)
        }
    }

    func validate() {
        if self.mode == .MinMax, let current = FDHelper.shared.dateFrom(day: day, month: month, year: year), let max = maxDate, let min = minDate {
            if current > max {
                // select max date
                self.day = max.day()
                self.month = max.month()
                self.year = max.year()
                reload()
            } else if current < min {
                // select min date
                self.day = min.day()
                self.month = min.month()
                self.year = min.year()
                reload()
            } else {
            }
        }
    }


    func reload() {
        reloadDays()
        reloadMonths()
        reloadYears()
    }

    func reloadDays() {
        guard let indexPath = daysIndexPath else {return}
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! DaysCollectionViewCell
            cell.collectionView.reloadData()
        }
    }

    func reloadMonths() {
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
            cell.select(month: FDHelper.shared.month(number: month))
        }
    }

    func reloadYears() {
        // get indexpath of year
        guard let indexPath = yearsIndexPath else {return}
        // scroll to year
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! YearsCollectionViewCell
            cell.select(year: year)
        }
    }

    func changeMonth(to: String) {
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
        cell.select(month: to)
        // store month
        self.month = FDHelper.shared.month(name: to)
    }

    func changeYear(to: Int) {
        guard let indexPath = yearsIndexPath else {return}
        let cell = self.collectionView.cellForItem(at: indexPath) as! YearsCollectionViewCell
        cell.select(year: to)
        self.year = to
    }

    func currentDate() -> Date {
        if let date = FDHelper.shared.dateFrom(day: self.day, month: self.month, year: self.year) {
            return date
        } else {
            return Date()
        }
    }

    func daysInMonth() -> Int{
        return FDHelper.shared.daysIn(month: self.month, year: self.year)
    }

    func firstDayOfMonth() -> String {
        return FDHelper.shared.firstDayOf(month: self.month, year: self.year)
    }

    func lastDayOfMonth() -> String{
        return FDHelper.shared.lastDayOf(month: self.month, year: self.year)
    }

    func firstDayOfMonthIndex() -> Int {
        let day = firstDayOfMonth()
        let days = FDHelper.shared.days()
        if let i = days.index(of: day.shortHandDay()) {
            return i + days.count
        } else {
            return 0
        }
    }

    func lastDayOfMonthIndex() -> Int {
        return (firstDayOfMonthIndex() + daysInMonth())
    }

    func getYearsList() -> [Int] {
        var years: [Int] = [Int]()
        var minYear = FDHelper.minYear
        var maxYear = FDHelper.maxYear
        if let min = minDate {
            minYear = min.year()
        }
        if let max = maxDate {
            maxYear = max.year()
        }
        for i in minYear...maxYear {
            years.append(i)
        }
        return years
    }

    func style() {
        self.view.backgroundColor = Colors.background
        self.collectionView.backgroundColor = Colors.background
    }

    // MARK: Screen Rotation
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.alpha = 0

        coordinator.animate(alongsideTransition: nil) { _ in
            guard let p = self.parent else {return}
            FrameHelper.shared.sizeAndCenter(view: self.view, in: p)
            self.view.layoutIfNeeded()
            self.setCollectionViewLayout()
            self.collectionView.layoutIfNeeded()
            self.reload()
            self.view.alpha = 1
        }
    }

    func sendResult() {
        if let parent = self.parent, let viewWithTag = parent.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)

        if self.callBack != nil {
            return self.callBack!(FDHelper.shared.dateFrom(day: self.day, month: self.month, year: self.year)!)
        }

    }
}

// MARK: CollectionView
extension PickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func initCollectionView() {
        registerCell(name: "DaysCollectionViewCell")
        registerCell(name: "YearsCollectionViewCell")
        registerCell(name: "MonthsCollectionViewCell")
        registerCell(name: "ButtonCollectionViewCell")
        setCollectionViewLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func setCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }

    func daysCellSize() -> CGSize {
        let w = (self.collectionView.frame.width)
        return CGSize(width: w, height: w)
    }

    func WheelCellSize() -> CGSize {
        let w = (self.collectionView.frame.width)
        let h = ((self.collectionView.frame.height - self.collectionView.frame.width) / 3 )
        return CGSize(width: w, height: h)
    }

    func registerCell(name: String) {
        collectionView.register(UINib(nibName: name, bundle: DatePicker.bundle), forCellWithReuseIdentifier: name)
    }

    func getDaysCell(indexPath: IndexPath) -> DaysCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "DaysCollectionViewCell", for: indexPath) as! DaysCollectionViewCell
    }

    func getMonthsCell(indexPath: IndexPath) -> MonthsCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MonthsCollectionViewCell", for: indexPath) as! MonthsCollectionViewCell
    }

    func getYearsCell(indexPath: IndexPath) -> YearsCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "YearsCollectionViewCell", for: indexPath) as! YearsCollectionViewCell
    }

    func getButtonCell(indexPath: IndexPath) -> ButtonCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            self.yearsIndexPath = indexPath
            let cell = getYearsCell(indexPath: indexPath)
            cell.setup(items: getYearsList(), parent: self)
            return cell
        case 1:
            self.monthsIndexPath = indexPath
            let cell = getMonthsCell(indexPath: indexPath)
            cell.setup(items: FDHelper.shared.months(), parent: self)
            return cell
        case 2:
            self.daysIndexPath = indexPath
            let cell = getDaysCell(indexPath: indexPath)
            cell.setup(parent: self)
            return cell
        default:
            self.buttonIndexPath = indexPath
            let cell = getButtonCell(indexPath: indexPath)
            cell.setup(date: FDHelper.shared.dateFrom(day: self.day, month: self.month, year: self.year)!) {
                self.sendResult()
            }
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 {
            return daysCellSize()
        } else {
            return WheelCellSize()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
