//
//  GroupInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct GroupInfo: Decodable {
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
}
