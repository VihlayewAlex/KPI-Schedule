//
//  Room.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation
import CoreLocation

struct Room {
    let id: Int
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(info: RoomInfo) {
        self.id = info.id
        self.name = info.name
        self.coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
    }
}
