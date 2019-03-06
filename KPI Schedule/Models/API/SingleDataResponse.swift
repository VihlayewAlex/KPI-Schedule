//
//  SingleDataResponse.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct SingleDataResponse<T: Decodable>: Decodable {
    var data: T
}
