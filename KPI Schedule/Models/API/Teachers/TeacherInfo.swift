//
//  TeacherInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct TeacherInfo: Codable {
    let id: Int
    let name: String
    let fullName: String
    let shortName: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "teacher_id"
        case fullName = "teacher_full_name"
        case shortName = "teacher_short_name"
        case name = "teacher_name"
        case url = "teacher_url"
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
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(String(id), forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(shortName, forKey: .shortName)
        try container.encode(url, forKey: .url)
    }
    
}
