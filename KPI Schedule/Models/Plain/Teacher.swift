//
//  Teacher.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct Teacher {
    let id: Int
    let fullName: String
    let shortName: String
    
    init(info: TeacherInfo) {
        self.id = info.id
        self.fullName = info.fullName
        self.shortName = info.shortName
    }
}
