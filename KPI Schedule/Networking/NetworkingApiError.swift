//
//  NetworkingApiError.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/7/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

enum NetworkingApiError: LocalizedError {
    // Data
    case noDataReturned
    // Pagination
    case invalidPaginationParams
    // Week number
    case weekNumberIsOutOfExpectedRange
    
    var localizedDescription: String {
        switch self {
        case .noDataReturned:
            return "No data returned as a response for the request"
        case .invalidPaginationParams:
            return "Pagination params do not satisfy requirements: limit > 0, offset >= 0"
        case .weekNumberIsOutOfExpectedRange:
            return "Week number can be constructed only from 1 or 2"
        }
    }
}
