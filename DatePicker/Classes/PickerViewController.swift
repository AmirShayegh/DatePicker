//
//  PickerViewController.swift
//  FreshDate
//
//  Created by Amir Shayegh on 2018-08-02.
//

import UIKit

public enum DisplayMode {
    case PopOver
    case Center
    case Bottom
}

public class PickerViewController: UIViewController {

    // MARK: Constants
    let notification = UINotificationFeedbackGenerator()
    let animationDuration: Double = 0.2

    // MARK: Optionals
    var callBack: ((_ selected: Bool, _ date: Date?)-> Void)?
    var yearlessCallBack: ((_ selected: Bool, _ month: Int?,_ day: Int?)-> Void)?

    var monthsIndexPath: IndexPath?
    var yearsIndexPath: IndexPath?
    var daysIndexPath: IndexPath?
    var buttonIndexPath: IndexPath?

    // MARK: Variables
    var loading: Bool = true

    var displayMode: DisplayMode = .Center
    var mode: DatePickerMode = .Basic
    var calledFromSwipe: Bool = false

    var day: Int = 18
    var month: Int = 7 {
        didSet {
            let max = DatePickerHelper.shared.daysIn(month: month, year: year)
            if day > max && !loading {
                day = max
            }
        }
    }
    var year: Int = 2018 {
        didSet {
            let max = DatePickerHelper.shared.daysIn(month: month, year: year)
            if day > max && !loading {
                day = max
            }
        }
    }

    var minDate: Date?
    var maxDate: Date?

    var minMonth: Int = 1
    var minDay: Int = 1
    var maxMonth: Int = 1
    var maxDay: Int = 1

    var selectButtonTitle: String = "Select"
    var selectButtonFont: UIFont?

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        style()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // allow the same picker instance to be shown again
        resultSent = false
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading = false
        }
    }

    // MARK: Callbacks

    // The callback fires exactly once per presentation, whether the
    // user taps Select, swipes the sheet down, taps the backdrop in
    // center mode, or taps outside a popover.
    private var resultSent = false

    func finish(selected: Bool) {
        if resultSent { return }
        resultSent = true
        notification.notificationOccurred(selected ? .success : .error)
        if mode == .Yearless {
            guard let callback = yearlessCallBack else { return }
            if selected {
                var d = day
                if d > daysInMonth() {
                    d = daysInMonth()
                }
                callback(true, month, d)
            } else {
                callback(false, nil, nil)
            }
        } else {
            guard let callback = callBack else { return }
            if selected {
                callback(true, DatePickerHelper.shared.dateFrom(day: day, month: month, year: year))
            } else {
                callback(false, nil)
            }
        }
    }

    // select button tapped
    func selectTapped() {
        if loading { return }
        finish(selected: true)
        dismiss(animated: true)
    }

    // backdrop tapped in center mode
    func cancelFromBackdrop() {
        finish(selected: false)
        dismiss(animated: true)
    }

    // MARK: Utility Functions
    func set(date: Date) {
        self.year = date.year()
        self.month = date.month()
        self.day = date.day()
    }
    
    func changeDay(to: Int) {
        self.day = to
        reloadDays()
    }

    func reloadButton() {
        validate()
    }

    func validate() {

        // Min Max mode validations
        if self.mode == .MinMax, let current = DatePickerHelper.shared.dateFrom(day: day, month: month, year: year), let max = maxDate, let min = minDate {
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
            }
        }

        // Yearless mode validations
        if self.mode == .Yearless {
            if month > maxMonth {
                self.month = maxMonth
                self.day = maxDay
                reload()
            } else if month == maxMonth && day > maxDay {
                day = maxDay
                reload()
            } else if month < minMonth {
                self.month = minMonth
                self.day = minDay
                reload()
            } else if month == minMonth && day < minDay {
                day = minDay
                reload()
            }
        }
    }

    func reload() {
        reloadDays()
        reloadMonths()
        reloadYears()
    }

    func YearOrMonthChanged() {
        self.reloadDays()
        self.reloadButton()
    }

    func lockDays() {
        guard let indexPath = daysIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? DaysCollectionViewCell else {return}
        cell.isUserInteractionEnabled = false
    }

    func unlockDays() {
        guard let indexPath = daysIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? DaysCollectionViewCell else {return}
        cell.isUserInteractionEnabled = true
    }

    func reloadDays() {
        guard let indexPath = daysIndexPath, let cell = collectionView.cellForItem(at: indexPath) as? DaysCollectionViewCell else {return}
//        let fadeDuration: Double = 0.2
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            cell.collectionView.reloadData()
            return
            /*
            if !calledFromSwipe {
                cell.randomReload(done: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        cell.collectionView.reloadData()
                    }
                })
            } else {
                cell.collectionView.reloadData()
            }*/
        }
    }

    func reloadMonths() {
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
            cell.select(month: DatePickerHelper.shared.month(number: month))
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

    func goToNextMonth() {
        var nextMonth = self.month + 1
        if nextMonth > 12 {
            nextMonth = 12
        }
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
        cell.select(month: DatePickerHelper.shared.month(number: nextMonth))
        // store month
        self.month = nextMonth
    }

    func goToPrevMonth() {
        var prevMonth = self.month - 1
        if prevMonth < 1 {
            prevMonth = 1
        }
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
        cell.select(month: DatePickerHelper.shared.month(number: prevMonth))
        // store month
        self.month = prevMonth
    }

    func changeMonth(to: String) {
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
        cell.select(month: to)
        // store month
        self.month = DatePickerHelper.shared.month(name: to)
    }

    func changeYear(to: Int) {
        guard let indexPath = yearsIndexPath else {return}
        let cell = self.collectionView.cellForItem(at: indexPath) as! YearsCollectionViewCell
        cell.select(year: to)
        self.year = to
    }

    func currentDate() -> Date {
        if let date = DatePickerHelper.shared.dateFrom(day: self.day, month: self.month, year: self.year) {
            return date
        } else {
            return Date()
        }
    }

    func daysInMonth() -> Int {
        return DatePickerHelper.shared.daysIn(month: self.month, year: self.year)
    }

    func firstDayOfMonth() -> String {
        return DatePickerHelper.shared.firstDayOf(month: self.month, year: self.year)
    }

    func lastDayOfMonth() -> String {
        return DatePickerHelper.shared.lastDayOf(month: self.month, year: self.year)
    }

    func firstDayOfMonthIndex() -> Int {
        let days = DatePickerHelper.shared.days()
        return DatePickerHelper.shared.firstWeekdayColumn(month: month, year: year) + days.count
    }

    func lastDayOfMonthIndex() -> Int {
        return (firstDayOfMonthIndex() + daysInMonth())
    }

    func getYearsList() -> [Int] {
        var years: [Int] = [Int]()
        var minYear = DatePickerHelper.minYear
        var maxYear = DatePickerHelper.maxYear
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
        self.view.backgroundColor = DatePickerColors.background
        self.collectionView.backgroundColor = DatePickerColors.background
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        })
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
        switch self.mode {
        case .Basic, .MinMax:
            // Square when space allows; shrinks in short layouts
            // (e.g. landscape) leaving room for the wheel rows.
            let minRowHeight: CGFloat = 44
            let available = self.collectionView.frame.height - (minRowHeight * 3)
            let side = min(w, max(available, minRowHeight))
            return CGSize(width: w, height: side)
        case .Yearless:
            return FrameHelper.shared.getYearlessDaysCellSize(for: w)
        }
    }

    func WheelCellSize() -> CGSize {
        var numberOfRows = 3 // years, months, select button
        if self.mode == .Yearless {
            numberOfRows = 2 // months, select button
        }
        let w = (self.collectionView.frame.width)
        let h = max((self.collectionView.frame.height - daysCellSize().height) / CGFloat(numberOfRows), 0)
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
        switch self.mode {
        case .Basic:
            return 4
        case .MinMax:
            return 4
        case .Yearless:
            return 3
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.mode {
        case .Basic:
            if indexPath.row == 2 {
                return daysCellSize()
            } else {
                return WheelCellSize()
            }
        case .MinMax:
            if indexPath.row == 2 {
                return daysCellSize()
            } else {
                return WheelCellSize()
            }
        case .Yearless:
            if indexPath.row == 1 {
                return daysCellSize()
            } else {
                return WheelCellSize()
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        switch indexPath.row {
        case 0:
            self.yearsIndexPath = indexPath
            let cell = getYearsCell(indexPath: indexPath)
            cell.setup(items: getYearsList(), parent: self)
            return cell
        case 1:
            self.monthsIndexPath = indexPath
            let cell = getMonthsCell(indexPath: indexPath)
            cell.setup(items: DatePickerHelper.shared.months(), parent: self)
            return cell
        case 2:
            self.daysIndexPath = indexPath
            let cell = getDaysCell(indexPath: indexPath)
            cell.setup(mode: self.mode, parent: self)
            return cell
        default:
            self.buttonIndexPath = indexPath
            let cell = getButtonCell(indexPath: indexPath)
            cell.setup(title: selectButtonTitle, font: selectButtonFont) {
                self.selectTapped()
            }
            return cell
        }
    }

    func getMinMaxModeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        return getBasicModeCell(for: indexPath)
    }

    func getYearlessModeCell(for indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            self.monthsIndexPath = indexPath
            let cell = getMonthsCell(indexPath: indexPath)
            cell.setup(items: DatePickerHelper.shared.months(), parent: self)
            return cell
        case 1:
            self.daysIndexPath = indexPath
            let cell = getDaysCell(indexPath: indexPath)
            cell.setup(mode: self.mode, parent: self)
            return cell
        default:
            self.buttonIndexPath = indexPath
            let cell = getButtonCell(indexPath: indexPath)
            cell.setup(title: selectButtonTitle, font: selectButtonFont) {
                self.selectTapped()
            }
            return cell
        }
    }
}

// MARK: Presentation delegates
extension PickerViewController: UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate {

    // Keep popovers as popovers in every size class so the layout
    // (and the Select button) stays consistent.
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    // User-initiated dismissal: tapping outside a popover commits the
    // current selection (matching v1 popover behavior, where there is
    // no cancel affordance); pulling a sheet down cancels.
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finish(selected: displayMode == .PopOver)
    }

    // Center mode uses a custom presentation controller for the
    // dimmed, tap-to-cancel backdrop.
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DatePickerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
