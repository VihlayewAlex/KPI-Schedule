//
//  Schedule.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct Schedule {
    let first: Week
    let second: Week
    
    var weeks: [Week] {
        return [first, second]
    }
}

extension Schedule {
    
    init(timetable: TimetableInfo) {
        first = Week(info: timetable.weeks.first)
        second = Week(info: timetable.weeks.second)
    }
    
}
