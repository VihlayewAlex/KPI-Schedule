//
//  Day.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct Day {
    let first: Lesson?
    let second: Lesson?
    let third: Lesson?
    let fourth: Lesson?
    let fifth: Lesson?
    let sixth: Lesson?
    let seventh: Lesson?
    let eighth: Lesson?
    let ninth: Lesson?
    let tenth: Lesson?
    
    var lessons: [Lesson?] {
        return [first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth]
    }
}

extension Day {
    
    init(info: DayInfo) {
        if let lessonInfo = info.lessons.first(where: { $0.number == 1 }) {
            first = Lesson(info: lessonInfo)
        } else {
            first = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 2 }) {
            second = Lesson(info: lessonInfo)
        } else {
            second = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 3 }) {
            third = Lesson(info: lessonInfo)
        } else {
            third = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 4 }) {
            fourth = Lesson(info: lessonInfo)
        } else {
            fourth = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 5 }) {
            fifth = Lesson(info: lessonInfo)
        } else {
            fifth = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 6 }) {
            sixth = Lesson(info: lessonInfo)
        } else {
            sixth = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 7 }) {
            seventh = Lesson(info: lessonInfo)
        } else {
            seventh = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 8 }) {
            eighth = Lesson(info: lessonInfo)
        } else {
            eighth = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 9 }) {
            ninth = Lesson(info: lessonInfo)
        } else {
            ninth = nil
        }
        if let lessonInfo = info.lessons.first(where: { $0.number == 10 }) {
            tenth = Lesson(info: lessonInfo)
        } else {
            tenth = nil
        }
    }
    
}
