//
//  DayInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct DayInfo: Codable {
    let dayNumber: DayOfWeek
    let lessons: [LessonInfo]
    
    enum CodingKeys: String, CodingKey {
        case lessons
        case dayNumber = "day_number"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dayNumberInt = try? container.decode(Int.self, forKey: .dayNumber), let dayNumber = DayOfWeek(number: dayNumberInt) {
            self.dayNumber = dayNumber
        } else {
            throw DecodingError.typeMismatch(DayInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "day_number value is not convertible to Int"))
        }
        lessons = try container.decode([LessonInfo].self, forKey: .lessons)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lessons, forKey: .lessons)
        try container.encode(dayNumber.number, forKey: .dayNumber)
    }
    
}
