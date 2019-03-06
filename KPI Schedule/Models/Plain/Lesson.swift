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
    let number: Int
    let timeStart: String
    let timeEnd: String
    let teachers: [Teacher]
    let rooms: [Room]
}

extension Lesson {
    
    init(info: LessonInfo) {
        self.name = info.name
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
