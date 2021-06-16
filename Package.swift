// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "DatePicker",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "DatePicker",
            targets: ["DatePicker"]),
    ],
    targets: [
        .target(
            name: "DatePicker",
            path: "DatePicker/Classes",
            exclude: [".gitkeep"],
            resources: [
                .process("en.lproj/DayCollectionViewCell.xib"),
                .process("ButtonCollectionViewCell.xib"),
                .process("DayHeaderCollectionViewCell.xib"),
                .process("DaysCollectionViewCell.xib"),
                .process("MonthCollectionViewCell.xib"),
                .process("MonthsCollectionViewCell.xib"),
                .process("YearCollectionViewCell.xib"),
                .process("YearsCollectionViewCell.xib")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
