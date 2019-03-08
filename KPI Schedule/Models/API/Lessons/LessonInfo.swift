//
//  LessonInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct LessonInfo: Decodable {
    let name: String
    let number: Int
    let type: String
    let timeStart: String
    let timeEnd: String
    let teachers: [TeacherInfo]
    let rooms: [RoomInfo]
    
    enum CodingKeys: String, CodingKey {
        case day = "day_number"
        case name = "lesson_name"
        case number = "lesson_number"
        case type = "lesson_type"
        case week = "lesson_week"
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case teachers, rooms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        if let numberString = try? container.decode(String.self, forKey: .number), let _number = Int(numberString) {
            number = _number
        } else {
            throw DecodingError.typeMismatch(LessonInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "lesson_number value is not convertible to Int"))
        }
        type = try container.decode(String.self, forKey: .type)
        timeStart = try container.decode(String.self, forKey: .timeStart)
        timeEnd = try container.decode(String.self, forKey: .timeEnd)
        teachers = try container.decode([TeacherInfo].self, forKey: .teachers)
        rooms = try container.decode([RoomInfo].self, forKey: .rooms)
    }
}
