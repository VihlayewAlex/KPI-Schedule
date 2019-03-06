//
//  NetworkingAPIFacade.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation
import PromiseKit

struct NetworkingAPIFacade {
    
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
                packetHandler(Handler.failure(error))
            }
        }
    }
    
    func getSchedule(forGroupWithId groupId: Int) -> Promise<Schedule> {
        return Promise(resolver: { (resolver) in
            self.apiService.getTimetable(groupId: groupId).done({ (response) in
                let timetableInfo = response.data
                let schedule = Schedule(timetable: timetableInfo)
                resolver.fulfill(schedule)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }
    
    func getTeachers(forGroupWithId groupId: Int) -> Promise<[Teacher]> {
        return Promise(resolver: { (resolver) in
            self.apiService.getTeachers(groupId: groupId).done({ (response) in
                let teachersInfo = response.data
                let teachers = teachersInfo.map({ (teacherInfo) -> Teacher in
                    return Teacher(info: teacherInfo)
                })
                resolver.fulfill(teachers)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }
    
    func searchTeachers(byString searchString: String) -> Promise<[Teacher]> {
        return Promise(resolver: { (resolver) in
            self.apiService.searchTeachers(string: searchString).done({ (response) in
                let teachersInfo = response.data
                let teachers = teachersInfo.map({ (teacherInfo) -> Teacher in
                    return Teacher(info: teacherInfo)
                })
                resolver.fulfill(teachers)
            }).catch({ (error) in
                resolver.reject(error)
            })
        })
    }
    
}
