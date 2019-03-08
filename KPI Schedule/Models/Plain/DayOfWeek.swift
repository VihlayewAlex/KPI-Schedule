//
//  DayOfWeek.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

enum DayOfWeek {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    init?(number: Int) {
        switch number {
        case 1:
            self = .monday
        case 2:
            self = .tuesday
        case 3:
            self = .wednesday
        case 4:
            self = .thursday
        case 5:
            self = .friday
        case 6:
            self = .saturday
        case 7:
            self = .sunday
        default:
            return nil
        }
    }
    
    init?(USAnumber: Int) {
        switch USAnumber {
        case 1:
            self = .sunday
        case 2:
            self = .monday
        case 3:
            self = .tuesday
        case 4:
            self = .wednesday
        case 5:
            self = .thursday
        case 6:
            self = .friday
        case 7:
            self = .saturday
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
    
    var index: Int {
        switch self {
        case .monday:
            return 0
        case .tuesday:
            return 1
        case .wednesday:
            return 2
        case .thursday:
            return 3
        case .friday:
            return 4
        case .saturday:
            return 5
        case .sunday:
            return 6
        }
    }
}
