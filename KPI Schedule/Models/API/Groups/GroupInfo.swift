//
//  GroupInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct GroupInfo: Codable {
    let id: Int
    let name: String
    let okr: GroupOKR
    let type: GroupType
    
    enum CodingKeys: String, CodingKey {
        case id = "group_id"
        case name = "group_full_name"
        case okr = "group_okr"
        case type = "group_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        if let okrString = try? container.decode(String.self, forKey: .okr), let _okr = GroupOKR(string: okrString) {
            okr = _okr
        } else {
            throw DecodingError.typeMismatch(GroupInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Can't match okr value to GroupOKR enum case"))
        }
        if let typeString = try? container.decode(String.self, forKey: .type), let _type = GroupType(string: typeString) {
            type = _type
        } else {
            throw DecodingError.typeMismatch(GroupInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Can't match type value to GroupType enum case"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(okr.name, forKey: .okr)
        try container.encode(type.name, forKey: .type)
    }
}

extension GroupInfo {
    
    init(id: Int, name: String, okr: GroupOKR, type: GroupType) {
        self.id = id
        self.name = name
        self.okr = okr
        self.type = type
    }
    
}

extension GroupInfo: Equatable {
    
    static func == (lhs: GroupInfo, rhs: GroupInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
}
