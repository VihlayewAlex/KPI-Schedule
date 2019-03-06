//
//  ArrayDataResponse.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct ArrayDataResponse<T: Decodable>: Decodable {
    var data: [T]
}

struct ArrayDataMetadataResponse<M: Decodable, T: Decodable>: Decodable {
    var meta: M
    var data: [T]
}
