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
pod 'DatePicker', '0.1.1'
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
datePicker.setup() { (date) in
	//Process Date returned when date changed
	print("\(date)")
}) { (date) in
	// Process Date returned when select button is pressed
	print("\(date)")
}
```

![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/DatePicker1.gif)

- Picker with minimum and maximum dates:

```Swift
let datePicker = DatePicker()
datePicker.setup(min: minDate, max: maxDate) { (date) in
	//Process Date returned when date changed
	print("\(date)")
}) { (date) in
	// Process Date returned when select button is pressed
	print("\(date)")
}
``` 

In the example below we have set minDate and maxDate to be between July 18, 2011 and September 10, 2020
![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/DatePicker2.gif)

3) Display

- Screen Center:
```Swift
datePicker.display(in: self)
```

- Or as Popover:
```Swift
datePicker.displayPopOver(on: button, in: self)
```

![Alt Text](https://github.com/AmirShayegh/DatePicker/blob/master/ReadmeFiles/Popover.jpg)

## Credit
- [Designed by Roop Jawl](https://www.linkedin.com/in/roopjawl/)
- [Developed by Amir Shayegh](https://www.linkedin.com/in/shayegh/)

## License

DatePicker is available under the MIT license. See the LICENSE file for more info.
