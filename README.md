# DatePicker

[![CI Status](https://img.shields.io/travis/amirshayegh/DatePicker.svg?style=flat)](https://travis-ci.org/amirshayegh/DatePicker)
[![Version](https://img.shields.io/cocoapods/v/DatePicker.svg?style=flat)](https://cocoapods.org/pods/DatePicker)
[![License](https://img.shields.io/cocoapods/l/DatePicker.svg?style=flat)](https://cocoapods.org/pods/DatePicker)
[![Platform](https://img.shields.io/cocoapods/p/DatePicker.svg?style=flat)](https://cocoapods.org/pods/DatePicker)


![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/Full.PNG)


## Installation

DatePicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DatePicker', '1.0.0'
```

## Quick Usage

1) Import the library

```Swift
import UIKit
import DatePicker

class ViewController: UIViewController {
}
```

2) Setup

- Picker between today and 100 years from now:

```Swift
let datePicker = DatePicker()
datePickersetup { (selected, date) in
	if selected, let selectedDate = date {
		print("\(selectedDate)"
	} else {
		print("cancelled")
	}
}
```

- Picker with minimum and maximum dates:

```Swift
let datePicker = DatePicker()
datePicker.setup(min: minDate, max: maxDate) { (selected, date) in
	if selected, let selectedDate = date {
		print("\(selectedDate)"
	} else {
		print("cancelled")
	}
}
```

You could also use DatePickerHelper's functions to help generate dates:

```Swift
let minDate = FDHelper.shared.dateFrom(day: 18, month: 08, year: 1990)
let maxDate = FDHelper.shared.dateFrom(day: 18, month: 08, year: 2020)
```

- Yearless Picker: select and return day and month integers independent of year. 

```Swift
let datePicker = DatePicker()
datePicker.setupYearless { (selected, month, day) in
	if selected, let day = day, let month = month {
		print("selected \(month) \(day)")
		// You can also use DatePickerHelper's functions:
		// FDHelper.shared.month(number: Int) will return the month string name
		print("selected FDHelper.shared.month(number: month) \(day)")
	} else {
		print("cancelled")
	}
}
``` 
![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/Yearless.png)

3) Display

- Screen Center:
```Swift
datePicker.display(in: self)
```

- Or as Popover (for iPads):
```Swift
datePicker.displayPopOver(on: button, in: self)
```

![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/Popover.jpg)

## Credit
- [Designed by Roop Jawl](https://www.linkedin.com/in/roopjawl/)
- [Developed by Amir Shayegh](https://www.linkedin.com/in/shayegh/)

![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/DatePicker.gif)

## License

DatePicker is available under the MIT license. See the LICENSE file for more info.
