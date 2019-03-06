//
//  Week.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct Week {
    let monday: Day?
    let tuesday: Day?
    let wednesday: Day?
    let thursday: Day?
    let friday: Day?
    let saturday: Day?
    let sunday: Day?
    
    var days: [Day?] {
        return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    }
}

extension Week {
    
    init(info: WeekInfo) {
        if let mondayInfo = info.days.monday {
            monday = Day(info: mondayInfo)
        } else {
            monday = nil
        }
        if let tuesdayInfo = info.days.tuesday {
            tuesday = Day(info: tuesdayInfo)
        } else {
            tuesday = nil
        }
        if let wednesdayInfo = info.days.wednesday {
            wednesday = Day(info: wednesdayInfo)
        } else {
            wednesday = nil
        }
        if let thursdayInfo = info.days.thursday {
            thursday = Day(info: thursdayInfo)
        } else {
            thursday = nil
        }
        if let fridayInfo = info.days.friday {
            friday = Day(info: fridayInfo)
        } else {
            friday = nil
        }
        if let saturdayInfo = info.days.saturday {
            saturday = Day(info: saturdayInfo)
        } else {
            saturday = nil
        }
        if let sundayInfo = info.days.sunday {
            sunday = Day(info: sundayInfo)
        } else {
            sunday = nil
        }
    }
    
}
