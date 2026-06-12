//
//  ExtensionsTests.swift
//  DatePickerTests
//

import XCTest
@testable import DatePicker

final class ExtensionsTests: XCTestCase {

    func testHexColorParsing() {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

        UIColor(hex: "#FF0000").getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 1, accuracy: 0.001)
        XCTAssertEqual(green, 0, accuracy: 0.001)
        XCTAssertEqual(blue, 0, accuracy: 0.001)
        XCTAssertEqual(alpha, 1, accuracy: 0.001)

        UIColor(hex: "00ff00").getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, 0, accuracy: 0.001)
        XCTAssertEqual(green, 1, accuracy: 0.001)
        XCTAssertEqual(blue, 0, accuracy: 0.001)

        UIColor(hex: "#234075").getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssertEqual(red, CGFloat(0x23) / 255, accuracy: 0.001)
        XCTAssertEqual(green, CGFloat(0x40) / 255, accuracy: 0.001)
        XCTAssertEqual(blue, CGFloat(0x75) / 255, accuracy: 0.001)
    }

    func testInvalidHexFallsBackToGray() {
        var white: CGFloat = 0, alpha: CGFloat = 0
        UIColor(hex: "nope").getWhite(&white, alpha: &alpha)
        XCTAssertEqual(white, 0.5, accuracy: 0.001)
        XCTAssertEqual(alpha, 1, accuracy: 0.001)
    }
}
