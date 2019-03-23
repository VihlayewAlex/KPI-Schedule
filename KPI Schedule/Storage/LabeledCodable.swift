//
//  LabeledCodable.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/22/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct LabeledCodable<T: Codable>: Codable {
    let value: T
    let label: String
    
    init(value: T, label: String) {
        self.value = value
        self.label = label
    }
}
