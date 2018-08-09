# DatePicker

[![CI Status](https://img.shields.io/travis/amirshayegh/DatePicker.svg?style=flat)](https://travis-ci.org/amirshayegh/DatePicker)
[![Version](https://img.shields.io/cocoapods/v/DatePicker.svg?style=flat)](https://cocoapods.org/pods/DatePicker)
[![License](https://img.shields.io/cocoapods/l/DatePicker.svg?style=flat)](https://cocoapods.org/pods/DatePicker)
[![Platform](https://img.shields.io/cocoapods/p/DatePicker.svg?style=flat)](https://cocoapods.org/pods/DatePicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DatePicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DatePicker'
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
datePicker.setup() {date in
	// process result
	print("\(date)")
}
```

![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/DatePicker1.gif)

- Picker with minimum and maximum dates:

```Swift
let datePicker = DatePicker()
datePicker.setup(min: minDate, max: maxDate) { (date) in
	// process result when date is returned
	print("\(date)")
}
```

![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/DatePicker1.gif)
In the example above we have set minDate and maxDate to be between July 18, 2011 and September 10, 2020

3) Display

- Screen Center:
```Swift
datePicker.display(in: self)
```

- Or as Popover:
```Swift
datePicker.displayPopOver(on: button, in: self)
```

## License

DatePicker is available under the MIT license. See the LICENSE file for more info.
