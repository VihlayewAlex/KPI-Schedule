//
//  Notification+Extensions.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/11/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

extension Notification {
    
    static var groupChanged: Notification {
        return Notification(name: Notification.Name("GroupChanged"))
    }
    
    static var scheduleTabTapped: Notification {
        return Notification(name: Notification.Name("ScheduleTabTapped"))
    }
    
    static var route: Notification {
        return Notification(name: Notification.Name("Route"))
    }
    
}
