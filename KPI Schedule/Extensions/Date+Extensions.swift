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
    
    var lessonIndex: Int? {
        var lessonsTime = [(Date, Date)]()
        for _ in 0..<10 {
            let start = lessonsTime.last?.1.addingTimeInterval(60 * 20) ?? Calendar.current.startOfDay(for: self).addingTimeInterval((60 * 30) + (60 * 60 * 8))
            let end = start.addingTimeInterval(60 * 95)
            lessonsTime.append((start, end))
        }
        let currentDate = self
        return lessonsTime.firstIndex(where: { (timeframe) -> Bool in
            let (lhs, rhs) = timeframe
            return (lhs < currentDate) && (currentDate < rhs)
        })
    }
    
    var lessonFraction: Double? {
        guard let currentLessonIndex = self.lessonIndex else {
            return nil
        }
        var lessonsTime = [(Date, Date)]()
        for _ in 0..<10 {
            let start = lessonsTime.last?.1.addingTimeInterval(60 * 20) ?? Calendar.current.startOfDay(for: self).addingTimeInterval((60 * 30) + (60 * 60 * 8))
            let end = start.addingTimeInterval(60 * 95)
            lessonsTime.append((start, end))
        }
        let currentTimeframe = lessonsTime[currentLessonIndex]
        let totalTimeInterval = 60 * 95
        let currentOffset = self.timeIntervalSince(currentTimeframe.0)
        return currentOffset / Double(totalTimeInterval)
    }
    
}
