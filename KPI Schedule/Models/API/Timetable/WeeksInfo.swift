//
//  WeeksInfo.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct WeeksInfo: Decodable {
    let first: WeekInfo
    let second: WeekInfo
    
    enum CodingKeys: String, CodingKey {
        case first = "1"
        case second = "2"
    }
}
