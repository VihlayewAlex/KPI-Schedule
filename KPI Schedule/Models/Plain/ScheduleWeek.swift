//
//  ScheduleWeek.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

enum ScheduleWeek {
    case first
    case second
    
    var number: Int {
        switch self {
        case .first:
            return 1
        case .second:
            return 2
        }
    }
    
    var index: Int {
        switch self {
        case .first:
            return 0
        case .second:
            return 1
        }
    }
    
    init?(number: Int) {
        switch number {
        case 1:
            self = .first
        case 2:
            self = .second
        default:
            return nil
        }
    }
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .first
        case 1:
            self = .second
        default:
            return nil
        }
    }
}
