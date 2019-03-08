//
//  DayOfWeekTests.swift
//  KPI Schedule Tests
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import XCTest

class DayOfWeekTests: XCTestCase {

    func testMonday() {
        XCTAssert(Date(timeIntervalSince1970: 1551668400).dayOfWeek == .monday, "Invalid monday conversion")
    }
    
    func testTuesday() {
        XCTAssert(Date(timeIntervalSince1970: 1551751200).dayOfWeek == .tuesday, "Invalid tuesday conversion")
    }
    
    func testWednesday() {
        XCTAssert(Date(timeIntervalSince1970: 1551834060).dayOfWeek == .wednesday, "Invalid wednesday conversion")
    }
    
    func testThursday() {
        XCTAssert(Date(timeIntervalSince1970: 1551993180).dayOfWeek == .thursday, "Invalid thursday conversion")
    }
    
    func testFriday() {
        XCTAssert(Date(timeIntervalSince1970: 1552014000).dayOfWeek == .friday, "Invalid friday conversion")
    }
    
    func testSaturday() {
        XCTAssert(Date(timeIntervalSince1970: 1552100400).dayOfWeek == .saturday, "Invalid saturday conversion")
    }
    
    func testSunday() {
        XCTAssert(Date(timeIntervalSince1970: 1552186800).dayOfWeek == .sunday, "Invalid sunday conversion")
    }

}
