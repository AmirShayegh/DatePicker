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
    let whiteScreenTag = 101
    let animationDuration: Double = 0.2

    // MARK: Optionals
    var callBack: ((_ selected: Bool, _ date: Date?)-> Void)?
    var liveCallBack: ((_ date: Date)-> Void)?
    var yearlessCallBack: ((_ month: Int,_ day: Int)-> Void)?

    var monthsIndexPath: IndexPath?
    var yearsIndexPath: IndexPath?
    var daysIndexPath: IndexPath?
    var buttonIndexPath: IndexPath?

    // MARK: Variables
    var displayMode: DisplayMode = .Center
    var mode: FreshDateMode = .Basic

    var calledFromSwipe: Bool = false
        
    var day: Int = 18 {
        didSet {
            liveReturn()
        }
    }
    var month: Int = 7 {
        didSet {
            liveReturn()
        }
    }
    var year: Int = 2018 {
        didSet {
            liveReturn()
        }
    }

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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Presentation
    func display(on parent: UIViewController) {
        parent.addChildViewController(self)
        FrameHelper.shared.positionBottomPreAnimation(view: self.view, in: parent)
        FrameHelper.shared.addShadow(to: self.view.layer)
        parent.view.addSubview(self.view)
        self.didMove(toParentViewController: parent)
        self.collectionView.alpha = 0
        setWhiteScreen()
        UIView.animate(withDuration: animationDuration, animations: {
            if self.displayMode == .Bottom {
                FrameHelper.shared.positionBottom(view: self.view, in: parent, size: parent.view.frame.size)
            } else {
                FrameHelper.shared.positionCenter(view: self.view, in: parent)
            }
            self.collectionView.alpha = 1
        }) { (done) in
        }
    }

    func setWhiteScreen() {
        guard let p = parent, let screen = whiteScreen() else {return}
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancelled(_:)))
        screen.alpha = 0
        p.view.insertSubview(screen, belowSubview: self.view)
        screen.addGestureRecognizer(tap)
        UIView.animate(withDuration: animationDuration, animations: {
            screen.alpha = 1
        })

    }

    func whiteScreen() -> UIView? {
        guard let p = parent else {return nil}
        let view = UIView(frame: CGRect(x: 0, y: 0, width: p.view.frame.width, height: p.view.frame.height))
        view.center.y = p.view.center.y
        view.center.x = p.view.center.x
        view.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.5)
        view.alpha = 1
        view.tag = whiteScreenTag
        return view
    }

    func removeWhiteScreen() {
        guard let p = parent else {return}
        if let viewWithTag = p.view.viewWithTag(whiteScreenTag) {
            viewWithTag.removeFromSuperview()
        }
    }

    @objc func cancelled(_ sender: UISwipeGestureRecognizer) {
        close()
    }

    func dimissAnimations(then: @escaping () -> Void) {
        if let p = parent, displayMode != .PopOver {
            UIView.animate(withDuration: animationDuration, animations: {
                if self.displayMode == .Bottom {
                    FrameHelper.shared.positionBottomPreAnimation(view: self.view, in: p)
                } else {
                    self.view.alpha = 0
                }
                if let whiteScreen = p.view.viewWithTag(self.whiteScreenTag) {
                    whiteScreen.alpha = 0
                }
            }) { (done) in
                self.remove()
                return then()
            }

        } else {
            self.remove()
            return then()
        }
    }


    // MARK: Callbacks
    func remove() {
        notification.notificationOccurred(.error)
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
        self.removeWhiteScreen()
        if self.callBack != nil {
            return self.callBack!(false, nil)
        }
    }

    // cancel
    func close() {

        dimissAnimations() {
            if self.callBack != nil {
                return self.callBack!(false, nil)
            }
        }

    }

    // select clicked
    func sendResult() {
        notification.notificationOccurred(.success)
        dimissAnimations() {
            if self.callBack != nil {
                return self.callBack!(true, FDHelper.shared.dateFrom(day: self.day, month: self.month, year: self.year))
            }
        }
    }

    // date changed
    func liveReturn() {
        // if date is valid, send back
        guard let date = FDHelper.shared.dateFrom(day: self.day, month: self.month, year: self.year) , let completion = self.liveCallBack else {return}
        if let min = self.minDate, let max = self.maxDate {
            if date < max && date > min {
                completion(date)
            }
        }
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
        //        guard let indexpath = buttonIndexPath else {return}
        //        if collectionView.indexPathsForVisibleItems.contains(indexpath) {
        //            let cell = collectionView.cellForItem(at: indexpath) as! ButtonCollectionViewCell
        //            cell.setFrom(date: FDHelper.shared.dateFrom(day: day, month: month, year: year)!)
        //        }
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

    func YearOrMonthChanged(back: Bool? = nil) {
//        if let monthWentBack = back {
//            flipDays(back: monthWentBack)
//        } else {
            self.reloadDays()
            self.reloadButton()
//        }
    }

    func reloadDays() {
        guard let indexPath = daysIndexPath else {return}
        let fadeDuration: Double = 0.2
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! DaysCollectionViewCell
            if !calledFromSwipe {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.alpha = 0
                    }, completion: { (done) in
                        cell.collectionView.reloadData()
                        UIView.animate(withDuration: fadeDuration, animations: {
                            cell.alpha = 1
                        })
                    })
                }
            } else {
                cell.collectionView.reloadData()
            }
        }
    }

    func flipDays(back: Bool) {
        guard let indexPath = daysIndexPath else {return}
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! DaysCollectionViewCell
            if back {
                let copy = FrameHelper.shared.getCloneView(of: cell)
                cell.collectionView.reloadData()
                flipLeft(view: cell, copy: copy)
            } else {
                flipRight(view: cell)
                cell.collectionView.reloadData()
            }

        }
    }

    @objc func flipLeft(view: UIView, copy: UIView) {
//        let copy = FrameHelper.shared.getCloneView( of: view)
        self.view.addSubview(copy)

        view.isHidden = true
        let transitionOptions: UIViewAnimationOptions = [.showHideTransitionViews, .transitionCurlDown]

        UIView.transition(with: copy, duration: 0.3, options: transitionOptions, animations: {
            copy.isHidden = true
            copy.removeFromSuperview()
        })

        UIView.transition(with: view, duration: 0.3, options: transitionOptions, animations: {
           view.isHidden = false
        })
    }

    @objc func flipRight(view: UIView) {
        guard let p = parent else {return}
        let copy = FrameHelper.shared.getCloneView( of: view)
        p.view.addSubview(copy)

        view.isHidden = true
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews, .transitionCurlUp]

        UIView.transition(with: copy, duration: 0.3, options: transitionOptions, animations: {
            copy.isHidden = true
            copy.removeFromSuperview()
        })

        UIView.transition(with: view, duration: 0.3, options: transitionOptions, animations: {
            view.isHidden = false
        })
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

    func goToNextMonth() {
        var nextMonth = self.month + 1
        if nextMonth > 12 {
            nextMonth = 12
        }
        // get indexpath of months
        guard let indexPath = monthsIndexPath else {return}
        // scroll to month
        let cell = self.collectionView.cellForItem(at: indexPath) as! MonthsCollectionViewCell
        cell.select(month: FDHelper.shared.month(number: nextMonth))
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
        cell.select(month: FDHelper.shared.month(number: prevMonth))
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

    func daysInMonth() -> Int {
        return FDHelper.shared.daysIn(month: self.month, year: self.year)
    }

    func firstDayOfMonth() -> String {
        return FDHelper.shared.firstDayOf(month: self.month, year: self.year)
    }

    func lastDayOfMonth() -> String {
        return FDHelper.shared.lastDayOf(month: self.month, year: self.year)
    }

    func firstDayOfMonthIndex() -> Int {
        let day = firstDayOfMonth()
        let days = FDHelper.shared.days()
        if let i = days.index(of: day.charactersUpTo(index: 3)) {
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.alpha = 0
        if self.displayMode == .PopOver {
            return
        } else {
            self.remove()
        }
         super.viewWillTransition(to: size, with: coordinator)
    }

//    // MARK: Screen Rotation
//    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        if self.displayMode == .PopOver {return}
//        guard let p = self.parent else {return}
//
////        if size.width > size.height {
////            // landscape
////
////        } else {
////            // portrait
////        }
//
//        self.removeWhiteScreen()
//        self.view.alpha = 0
//        if self.displayMode == .Bottom {
//            FrameHelper.shared.positionBottom(view: self.view, in: p, size: size)
//        } else {
//            FrameHelper.shared.positionCenter(view: self.view, in: p)
//        }
//        self.view.layoutIfNeeded()
//        self.setCollectionViewLayout()
//        self.collectionView.layoutIfNeeded()
//        self.reload()
//        self.view.alpha = 1
//        self.setWhiteScreen()
//
////        coordinator.animate(alongsideTransition: nil) { _ in
////            guard let p = self.parent else {return}
////            FrameHelper.shared.positionCenter(view: self.view, in: p)
////            self.view.layoutIfNeeded()
////            self.setCollectionViewLayout()
////            self.collectionView.layoutIfNeeded()
////            self.reload()
////            self.view.alpha = 1
////        }
//    }

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
