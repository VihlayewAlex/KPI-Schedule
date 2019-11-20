//
//  ErrorMessageResponse.swift
//  KPI Schedule
//
//  Created by Alex on 9/14/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

struct ErrorMessageResponse: Decodable {
    let statusCode: Int
    let timeStamp: UInt64
    let message: String
}
