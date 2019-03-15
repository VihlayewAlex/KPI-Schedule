//
//  LessonType.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit

enum LessonType {
    case lecture
    case laboratory
    case practice
    case unknown
    
    init(string: String) {
        switch string {
        case "Лек":
            self = .lecture
        case "Лаб":
            self = .laboratory
        case "Прак":
            self = .practice
        default:
            self = .unknown
        }
    }
    
    var name: String {
        switch self {
        case .lecture:
            return "Lec"
        case .laboratory:
            return "Lab"
        case .practice:
            return "Prac"
        case .unknown:
            return "???"
        }
    }
    
    var fullName: String {
        switch self {
        case .lecture:
            return "Lecture"
        case .laboratory:
            return "Laboratory"
        case .practice:
            return "Practice"
        case .unknown:
            return "???"
        }
    }
    
    var color: UIColor {
        switch self {
        case .lecture:
            return UIColor(red: 255 / 255, green: 187 / 255, blue: 75 / 255, alpha: 1.0)
        case .laboratory:
            return UIColor(red: 165 / 255, green: 86 / 255, blue: 233 / 255, alpha: 1.0)
        case .practice:
            return UIColor(red: 121 / 255, green: 213 / 255, blue: 33 / 255, alpha: 1.0)
        case .unknown:
            return UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1.0)
        }
    }
}
