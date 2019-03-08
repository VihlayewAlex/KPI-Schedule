//
//  Preferences.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

protocol Preferences {
    
    var selectedGroup: GroupInfo? { get set }
    
    var cachedTimetable: TimetableInfo? { get set }
    
}

struct InMemoryPreferences: Preferences {
    
    var selectedGroup: GroupInfo?
    
    var cachedTimetable: TimetableInfo?
    
}

struct OnDiskPreferences: Preferences {
    
    var selectedGroup: GroupInfo? {
        get {
            if let data = UserDefaults.standard.data(forKey: "selectedGroup") {
                let decoder = JSONDecoder()
                return try? decoder.decode(GroupInfo.self, from: data)
            } else {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: "selectedGroup")
                return
            }
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "selectedGroup")
        }
    }
    
    var cachedTimetable: TimetableInfo?
    
}
