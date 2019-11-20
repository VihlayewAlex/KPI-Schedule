//
//  NetworkingApi.swift
//  KPI Schedule
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import Foundation
import PromiseKit


// MARK: - API Service protocol

protocol APIService {
    
    func getGroups(limit: Int, offset: Int) -> Promise<ArrayDataMetadataResponse<GroupsResponseMeta, GroupInfo>>
    
    func getTeachers(groupId: Int) -> Promise<ArrayDataResponse<TeacherInfo>>
    
    func searchTeachers(string: String) -> Promise<ArrayDataResponse<TeacherInfo>>
    
    func getTimetable(groupId: Int) -> Promise<SingleDataResponse<TimetableInfo>>
    
    func getCurrentWeekNumber() -> Promise<SingleDataResponse<Int>>
    
}


// MARK: - Common networking logic

class NetworkingApi {
    
    private enum NetworkingApiTarget {
        case getGroups(limit: Int, offset: Int)
        case getLessons(groupId: Int)
        case getTeachers(groupId: Int)
        case searchTeachers(string: String)
        case getTimetable(groupId: Int)
        case getCurrentWeekNumber
        
        var url: URL {
            switch self {
            case .getGroups(let limit, let offset):
                return URL(string: "https://api.rozklad.org.ua/v2/groups/?filter={'limit':\(limit),'offset':\(offset)}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            case .getLessons(let groupId):
                return URL(string: "https://api.rozklad.org.ua/v2/groups/\(groupId)/lessons")!
            case .getTeachers(let groupId):
                return URL(string: "https://api.rozklad.org.ua/v2/groups/\(groupId)/teachers")!
            case .searchTeachers(let string):
                return URL(string: "https://api.rozklad.org.ua/v2/teachers/?search={'query':'\(string)'}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
            case .getTimetable(let groupId):
                return URL(string: "https://api.rozklad.org.ua/v2/groups/\(groupId)/timetable")!
            case .getCurrentWeekNumber:
                return URL(string: "https://api.rozklad.org.ua/v2/weeks")!
            }
        }
    }
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private func executePromiseRequest<T: Decodable>(to target: NetworkingApiTarget) -> Promise<T> {
        return Promise(resolver: { (resolver) in
            session.dataTask(with: target.url, completionHandler: { [unowned self] (data, response, error) in
                if let error = error {
                    resolver.reject(error)
                } else if let data = data {
                    do {
                        let response = try self.decoder.decode(T.self, from: data)
                        resolver.fulfill(response)
                    } catch {
                        if let response = try? self.decoder.decode(ErrorMessageResponse.self, from: data),
                            response.message == "Group not found" {
                            resolver.reject(NetworkingApiError.groupNotFound)
                        }
                        print("Decoding error:", error)
                        print("Couldn't decode value from data:", String(data: data, encoding: .utf8) ?? "nil")
                        resolver.reject(error)
                    }
                } else {
                    resolver.reject(NetworkingApiError.noDataReturned)
                }
            }).resume()
        })
    }
    
}


// MARK: - Concrete APIService implementation

extension NetworkingApi: APIService {

    func getGroups(limit: Int, offset: Int) -> Promise<ArrayDataMetadataResponse<GroupsResponseMeta, GroupInfo>> {
        guard limit > 0, offset >= 0 else {
            return Promise(error: NetworkingApiError.invalidPaginationParams)
        }
        return executePromiseRequest(to: .getGroups(limit: limit, offset: offset))
    }
    
    func getTeachers(groupId: Int) -> Promise<ArrayDataResponse<TeacherInfo>> {
        return executePromiseRequest(to: .getTeachers(groupId: groupId))
    }
    
    func searchTeachers(string: String) -> Promise<ArrayDataResponse<TeacherInfo>> {
        return executePromiseRequest(to: .searchTeachers(string: string))
    }
    
    func getTimetable(groupId: Int) -> Promise<SingleDataResponse<TimetableInfo>> {
        return executePromiseRequest(to: .getTimetable(groupId: groupId))
    }
    
    func getCurrentWeekNumber() -> Promise<SingleDataResponse<Int>> {
        return executePromiseRequest(to: .getCurrentWeekNumber)
    }

}
