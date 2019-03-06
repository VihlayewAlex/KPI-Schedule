//
//  RoomInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct RoomInfo: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "room_id"
        case name = "room_name"
        case latitude = "room_latitude"
        case longitude = "room_longitude"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let idString = try? container.decode(String.self, forKey: .id), let _id = Int(idString) {
            id = _id
        } else {
            throw DecodingError.typeMismatch(RoomInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "teacher_id value is not convertible to Int"))
        }
        name = try container.decode(String.self, forKey: .name)
        if let latitudeString = try? container.decode(String.self, forKey: .latitude), let _latitude = Double(latitudeString) {
            latitude = _latitude
        } else {
            throw DecodingError.typeMismatch(RoomInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "room_latitude value is not convertible to Double"))
        }
        if let longitudeString = try? container.decode(String.self, forKey: .longitude), let _longitude = Double(longitudeString) {
            longitude = _longitude
        } else {
            throw DecodingError.typeMismatch(RoomInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "room_longitude value is not convertible to Double"))
        }
    }
}
