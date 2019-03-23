//
//  NetworkingApiFacade.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation
import PromiseKit

struct NetworkingApiFacade {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    enum Handler<T> {
        case failure(Error)
        case success(T)
    }
    struct GetAllGroupsPacket {
        let nextPacket: [GroupInfo]
        let currentOffset: Int
        let totalCount: Int
        let isLast: Bool
    }
    
    func getAllGroups(packedBy limit: Int, callbackQueue: DispatchQueue, withHandler packetHandler: @escaping (Handler<GetAllGroupsPacket>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let groupsMeta = try self.apiService.getGroups(limit: 1, offset: 0).wait().meta
                var offset = 0
                while offset <= groupsMeta.totalCount {
                    let groupsInfo = try self.apiService.getGroups(limit: limit, offset: offset).wait().data
                    let isLastPacket = (offset + limit > groupsMeta.totalCount)
                    callbackQueue.async {
                        packetHandler(Handler.success(GetAllGroupsPacket(nextPacket: groupsInfo, currentOffset: offset, totalCount: groupsMeta.totalCount, isLast: isLastPacket)))
                    }
                    offset += limit
                }
            } catch {
                callbackQueue.async {
                    packetHandler(Handler.failure(error))
                }
            }
        }
    }
    
    func getSchedule(forGroupWithId groupId: Int, allowCached: Bool) -> Promise<Schedule> {
        if allowCached {
            if groupId == Preferences.selectedGroup?.id {
                if let cached = Preferences.cachedGroupTimetable {
                    return Promise.value(Schedule(timetable: cached))
                }
            } else if let cachedFavourite = Preferences.cachedFavouriteGroupTimetables.first(where: { $0.label == String(groupId) })?.value {
                return Promise.value(Schedule(timetable: cachedFavourite))
            }
        }
        return apiService.getTimetable(groupId: groupId).map({ (response) -> Schedule in
            if groupId == Preferences.selectedGroup?.id {
                Preferences.cachedGroupTimetable = response.data
            } else {
                Preferences.cachedFavouriteGroupTimetables += [LabeledCodable(value: response.data, label: String(groupId))]
            }
            return Schedule(timetable: response.data)
        })
    }
    
    func getTeachers(forGroupWithId groupId: Int) -> Promise<[Teacher]> {
        return apiService.getTeachers(groupId: groupId).map({ (response) -> [Teacher] in
            return response.data.map({ (teacherInfo) -> Teacher in
                return Teacher(info: teacherInfo)
            })
        })
    }
    
    func searchTeachers(byString searchString: String) -> Promise<[Teacher]> {
        return apiService.searchTeachers(string: searchString).map({ (response) -> [Teacher] in
            return response.data.map({ (teacherInfo) -> Teacher in
                return Teacher(info: teacherInfo)
            })
        })
    }
    
    func getCurrentWeekNumber() -> Promise<ScheduleWeek> {
        if let cached = Preferences.cachedWeekNumber,
            let updateTimestamp = Preferences.cachedWeekNumberUpdateTimestamp {
            let numberOfWeeksPast = Calendar.current.component(.day, from: Date(timeIntervalSince1970: updateTimestamp)) / 7
            return Promise.value(ScheduleWeek(number: (numberOfWeeksPast % 2 == 0) ? cached : (cached == 1 ? 2 : 1))!)
        }
        return Promise(resolver: { (resolver) in
            apiService.getCurrentWeekNumber().done({ (response) in
                if let week = ScheduleWeek(number: response.data) {
                    Preferences.cachedWeekNumber = week.number
                    Preferences.cachedWeekNumberUpdateTimestamp = Date().timeIntervalSince1970
                    resolver.fulfill(week)
                } else {
                    resolver.reject(NetworkingApiError.weekNumberIsOutOfExpectedRange)
                }
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }
    
}
