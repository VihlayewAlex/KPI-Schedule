//
//  TeacherInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct TeacherInfo: Decodable {
    let id: Int
    let fullName: String
    let shortName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "teacher_id"
        case fullName = "teacher_full_name"
        case shortName = "teacher_short_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let idString = try? container.decode(String.self, forKey: .id), let _id = Int(idString) {
            id = _id
        } else {
            throw DecodingError.typeMismatch(TeacherInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "teacher_id value is not convertible to Int"))
        }
        fullName = try container.decode(String.self, forKey: .fullName)
        shortName = try container.decode(String.self, forKey: .shortName)
    }
}
