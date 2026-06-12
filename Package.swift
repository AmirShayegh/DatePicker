// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DatePicker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "DatePicker", targets: ["DatePicker"])
    ],
    targets: [
        .target(
            name: "DatePicker",
            path: "DatePicker/Classes",
            resources: [
                .process("Picker.storyboard"),
                .process("ButtonCollectionViewCell.xib"),
                .process("DayCollectionViewCell.xib"),
                .process("DayHeaderCollectionViewCell.xib"),
                .process("DaysCollectionViewCell.xib"),
                .process("MonthCollectionViewCell.xib"),
                .process("MonthsCollectionViewCell.xib"),
                .process("YearCollectionViewCell.xib"),
                .process("YearsCollectionViewCell.xib")
            ]
        ),
        .testTarget(
            name: "DatePickerTests",
            dependencies: ["DatePicker"],
            path: "Tests/DatePickerTests"
        )
    ]
)
