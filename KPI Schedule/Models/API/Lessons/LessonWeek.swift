//
//  LessonWeek.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

enum LessonWeek {
    case first
    case second
    
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
}
