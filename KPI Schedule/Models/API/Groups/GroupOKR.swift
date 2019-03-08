//
//  GroupOKR.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

enum GroupOKR {
    case bachelor
    case magister
    case specialist
    
    init?(string: String) {
        switch string {
        case "bachelor":
            self = .bachelor
        case "magister":
            self = .magister
        case "specialist":
            self = .specialist
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .bachelor:
            return "bachelor"
        case .magister:
            return "magister"
        case .specialist:
            return "specialist"
        }
    }
}
