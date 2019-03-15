//
//  LessonLocationsDataSource.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/15/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import UIKit
import MapKit

class LessonLocationsDataSource: NSObject, UITableViewDataSource {
    
    private let rooms: [Room]
    
    init(locations: [Room]) {
        self.rooms = locations
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
        let room = rooms[indexPath.row]
        cell.mapView.addAnnotation({ () -> MKAnnotation in
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = room.coordinate
            pointAnnotation.title = room.name
            return pointAnnotation
        }())
        cell.mapView.setCenter(room.coordinate, animated: false)
        cell.mapView.camera.altitude = 190
        cell.mapView.showsBuildings = true
        return cell
    }
    
}
