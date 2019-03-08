//
//  Date+Extensions.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

extension Date {
    
    var dayOfWeek: DayOfWeek {
        let calendar = Calendar.current
        let component = calendar.component(.weekday, from: self)
        return DayOfWeek(USAnumber: component)!
    }
    
}
