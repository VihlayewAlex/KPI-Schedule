//
//  DaysInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct DaysInfo: Codable {
    let monday: DayInfo?
    let tuesday: DayInfo?
    let wednesday: DayInfo?
    let thursday: DayInfo?
    let friday: DayInfo?
    let saturday: DayInfo?
    let sunday: DayInfo?
    
    enum CodingKeys: String, CodingKey {
        case monday = "1"
        case tuesday = "2"
        case wednesday = "3"
        case thursday = "4"
        case friday = "5"
        case saturday = "6"
        case sunday = "7"
    }
}
