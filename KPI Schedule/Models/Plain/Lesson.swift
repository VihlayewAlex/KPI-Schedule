//
//  Lesson.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct Lesson {
    let name: String
    let type: LessonType
    let number: Int
    let timeStart: String
    let timeEnd: String
    let teachers: [Teacher]
    let rooms: [Room]
}

extension Lesson {
    
    var start: String {
        switch number {
        case 1:
            return "8:30"
        case 2:
            return "10:25"
        case 3:
            return "12:20"
        case 4:
            return "14:15"
        case 5:
            return "16:10"
        case 6:
            return "18:30"
        case 7:
            return "20:20"
        default:
            return "??"
        }
    }
    
    var end: String {
        switch number {
        case 1:
            return "10:05"
        case 2:
            return "12:00"
        case 3:
            return "13:55"
        case 4:
            return "15:50"
        case 5:
            return "17:45"
        case 6:
            return "20:05"
        case 7:
            return "21:55"
        default:
            return "??"
        }
    }
    
    var breakStart: String {
        switch number {
        case 1:
            return "9:15"
        case 2:
            return "11:10"
        case 3:
            return "13:05"
        case 4:
            return "15:00"
        case 5:
            return "16:55"
        case 6:
            return "19:15"
        case 7:
            return "21:05"
        default:
            return "??"
        }
    }
    
    var breakEnd: String {
        switch number {
        case 1:
            return "9:20"
        case 2:
            return "11:15"
        case 3:
            return "13:10"
        case 4:
            return "15:05"
        case 5:
            return "17:00"
        case 6:
            return "19:20"
        case 7:
            return "21:10"
        default:
            return "??"
        }
    }
    
}

extension Lesson {
    
    init(info: LessonInfo) {
        self.name = info.name
        self.type = LessonType(string: info.type)
        self.number = info.number
        self.timeStart = info.timeStart
        self.timeEnd = info.timeEnd
        self.teachers = info.teachers.map({ (teacherInfo) -> Teacher in
            return Teacher(info: teacherInfo)
        })
        self.rooms = info.rooms.map({ (roomInfo) -> Room in
            return Room(info: roomInfo)
        })
    }
    
}
