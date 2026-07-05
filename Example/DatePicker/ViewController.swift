//
//  ViewController.swift
//  DatePicker
//
//  Created by amirshayegh on 08/08/2018.
//  Copyright (c) 2018 amirshayegh. All rights reserved.
//

import UIKit
import DatePicker

class ViewController: UIViewController {

    private let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildUI()
    }

    private func buildUI() {
        resultLabel.text = "Pick a date"
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.font = .preferredFont(forTextStyle: .headline)

        let stack = UIStackView(arrangedSubviews: [
            resultLabel,
            demoButton("Sheet (basic)", #selector(showSheet)),
            demoButton("Sheet (min/max)", #selector(showMinMax)),
            demoButton("Popover (yearless)", #selector(showPopover)),
            demoButton("Center", #selector(showCenter)),
            demoButton("Custom button title", #selector(showCustomTitle)),
            demoButton("Inside a table view (issue #22)", #selector(showTableDemo)),
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private func demoButton(_ title: String, _ action: Selector) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        let button = UIButton(configuration: config)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func showResult(_ selected: Bool, _ date: Date?) {
        if selected, let date = date {
            resultLabel.text = "Selected \(date.formatted(date: .long, time: .omitted))"
        } else {
            resultLabel.text = "Cancelled"
        }
    }

    @objc private func showSheet() {
        let picker = DatePicker()
        picker.setup(beginWith: Date()) { [weak self] selected, date in
            self?.showResult(selected, date)
        }
        picker.show(in: self)
    }

    @objc private func showMinMax() {
        let picker = DatePicker()
        let min = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
        picker.setup(beginWith: Date(), min: min, max: max) { [weak self] selected, date in
            self?.showResult(selected, date)
        }
        picker.show(in: self)
    }

    @objc private func showPopover(_ sender: UIButton) {
        let picker = DatePicker()
        picker.setupYearless(minMonth: 3, minDay: 8) { [weak self] selected, month, day in
            if selected, let month = month, let day = day {
                self?.resultLabel.text = "Selected \(DatePickerHelper.shared.month(number: month)) \(day)"
            } else {
                self?.resultLabel.text = "Cancelled"
            }
        }
        picker.show(in: self, style: .popover, sourceView: sender)
    }

    @objc private func showCenter() {
        let picker = DatePicker()
        picker.setup(beginWith: Date()) { [weak self] selected, date in
            self?.showResult(selected, date)
        }
        picker.show(in: self, style: .center)
    }

    @objc private func showCustomTitle() {
        let picker = DatePicker()
        picker.selectButtonTitle = "Confirm 🎉"
        picker.setup(beginWith: Date()) { [weak self] selected, date in
            self?.showResult(selected, date)
        }
        picker.show(in: self)
    }

    @objc private func showTableDemo() {
        let table = TableDemoViewController(style: .insetGrouped)
        present(UINavigationController(rootViewController: table), animated: true)
    }
}

// Regression demo for issue #22: presenting from a
// UITableViewController must not clip the picker.
class TableDemoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table View"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(dismissSelf))
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Row \(indexPath.row + 1) — tap to pick a date"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let picker = DatePicker()
        picker.setup(beginWith: Date()) { selected, date in
            print(selected, date?.formatted(date: .long, time: .omitted) ?? "none")
        }
        picker.show(in: self)
    }
}
