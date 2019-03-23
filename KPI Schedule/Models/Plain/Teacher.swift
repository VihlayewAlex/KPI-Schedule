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
    let url: URL?
    
    init(info: TeacherInfo) {
        self.id = info.id
        self.fullName = !info.fullName.isEmpty ? info.fullName : info.name
        self.shortName = !info.shortName.isEmpty ? info.shortName : info.name
        self.url = URL(string: info.url)
    }
}
