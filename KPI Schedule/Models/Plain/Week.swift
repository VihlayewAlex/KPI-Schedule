//
//  Week.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct Week {
    let monday: Day
    let tuesday: Day
    let wednesday: Day
    let thursday: Day
    let friday: Day
    let saturday: Day
    let sunday: Day
    
    var days: [Day] {
        return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    }
}

extension Week {
    
    init(info: WeekInfo, number: ScheduleWeek) {
        if let mondayInfo = info.days.monday {
            monday = Day(info: mondayInfo)
        } else {
            monday = Day.empty(.monday)
        }
        if let tuesdayInfo = info.days.tuesday {
            tuesday = Day(info: tuesdayInfo)
        } else {
            tuesday = Day.empty(.tuesday)
        }
        if let wednesdayInfo = info.days.wednesday {
            wednesday = Day(info: wednesdayInfo)
        } else {
            wednesday = Day.empty(.wednesday)
        }
        if let thursdayInfo = info.days.thursday {
            thursday = Day(info: thursdayInfo)
        } else {
            thursday = Day.empty(.thursday)
        }
        if let fridayInfo = info.days.friday {
            friday = Day(info: fridayInfo)
        } else {
            friday = Day.empty(.friday)
        }
        if let saturdayInfo = info.days.saturday {
            saturday = Day(info: saturdayInfo)
        } else {
            saturday = Day.empty(.saturday)
        }
        if let sundayInfo = info.days.sunday {
            sunday = Day(info: sundayInfo)
        } else {
            sunday = Day.empty(.sunday)
        }
    }
    
}
