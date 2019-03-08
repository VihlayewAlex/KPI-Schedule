//
//  GroupType.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

enum GroupType {
    case daily
    case extramural
    
    init?(string: String) {
        switch string {
        case "daily":
            self = .daily
        case "extramural":
            self = .extramural
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .daily:
            return "daily"
        case .extramural:
            return "extramural"
        }
    }
}
