//
//  Preferences.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation

protocol PreferencesStorage {
    
    // MARK: Groups
    
    var selectedGroup: GroupInfo? { get set }
    
    var favouriteGroups: [GroupInfo] { get set }
    
    // MARK: Cache
    
    var cachedWeekNumber: Int? { get set }
    
    var cachedGroupTimetable: TimetableInfo? { get set }
    
    var cachedFavouriteGroupTimetables: [LabeledCodable<TimetableInfo>] { get set }
    
    // MARK: Tutorial
    
    var isScheduleTutorialShown: Bool { get set }
    
    // MARK: Cleaning
    
    mutating func clear()
    
}

struct InMemoryPreferences: PreferencesStorage {
    
    // MARK: Groups
    
    var selectedGroup: GroupInfo?
    
    var favouriteGroups = [GroupInfo]()
    
    // MARK: Cache
    
    var cachedWeekNumber: Int?
    
    var cachedGroupTimetable: TimetableInfo?
    
    var cachedFavouriteGroupTimetables = [LabeledCodable<TimetableInfo>]()
    
    // MARK: Tutorial
    
    var isScheduleTutorialShown: Bool = false
    
    // MARK: Cleaning
    
    mutating func clear() {
        selectedGroup = nil
        favouriteGroups = []
        cachedWeekNumber = nil
        cachedGroupTimetable = nil
        cachedFavouriteGroupTimetables = []
        isScheduleTutorialShown = false
    }
    
}

struct OnDiskPreferences: PreferencesStorage {
    
    // MARK: Groups
    
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
    
    var favouriteGroups: [GroupInfo] {
        get {
            if let data = UserDefaults.standard.data(forKey: "favouriteGroups") {
                let decoder = JSONDecoder()
                return (try? decoder.decode([GroupInfo].self, from: data)) ?? []
            } else {
                return []
            }
        }
        set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "favouriteGroups")
        }
    }
    
    // MARK: Cache
    
    var cachedWeekNumber: Int? {
        get {
            return (UserDefaults.standard.object(forKey: "cachedWeekNumber") as? Int)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "cachedWeekNumber")
        }
    }
    
    var cachedWeekNumberUpdateTimestamp: TimeInterval? {
        get {
            return (UserDefaults.standard.object(forKey: "cachedWeekNumberUpdateTimestamp") as? TimeInterval)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "cachedWeekNumberUpdateTimestamp")
        }
    }
    
    var cachedGroupTimetable: TimetableInfo? {
        get {
            if let data = UserDefaults.standard.data(forKey: "cachedGroupTimetable") {
                let decoder = JSONDecoder()
                return try? decoder.decode(TimetableInfo.self, from: data)
            } else {
                return nil
            }
        }
        set {
            guard let newValue = newValue else {
                UserDefaults.standard.removeObject(forKey: "cachedGroupTimetable")
                return
            }
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "cachedGroupTimetable")
        }
    }
    
    var cachedFavouriteGroupTimetables: [LabeledCodable<TimetableInfo>] {
        get {
            if let data = UserDefaults.standard.data(forKey: "cachedFavouriteGroupTimetables") {
                let decoder = JSONDecoder()
                return (try? decoder.decode([LabeledCodable<TimetableInfo>].self, from: data)) ?? []
            } else {
                return []
            }
        }
        set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: "cachedFavouriteGroupTimetables")
        }
    }
    
    // MARK: Tutorial
    
    var isScheduleTutorialShown: Bool {
        get {
            return (UserDefaults.standard.object(forKey: "isScheduleTutorialShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isScheduleTutorialShown")
        }
    }
    
    // MARK: Cleaning
    
    mutating func clear() {
        selectedGroup = nil
        favouriteGroups = []
        cachedWeekNumber = nil
        cachedGroupTimetable = nil
        cachedFavouriteGroupTimetables = []
        isScheduleTutorialShown = false
    }
    
}
