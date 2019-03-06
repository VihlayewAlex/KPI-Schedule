//
//  GroupsResponseMeta.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct GroupsResponseMeta: Decodable {
    let offset: Int
    let limit: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case limit, offset
        case totalCount = "total_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        offset = try container.decode(Int.self, forKey: .offset)
        limit = try container.decode(Int.self, forKey: .limit)
        if let totalCountString = try? container.decode(String.self, forKey: .totalCount), let _totalCount = Int(totalCountString) {
            totalCount = _totalCount
        } else {
            throw DecodingError.typeMismatch(GroupsResponseMeta.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Can't extract total count metadata value"))
        }
    }
}
