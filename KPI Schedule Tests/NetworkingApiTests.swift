//
//  NetworkingApiTests.swift
//  KPI Schedule Tests
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import XCTest
import PromiseKit

class NetworkingApiTests: XCTestCase {

    var API: NetworkingAPI!
    var exp: XCTestExpectation!
    
    override func setUp() {
        API = NetworkingAPI()
        exp = expectation(description: "Get and parse all JSONs")
    }

    override func tearDown() {
        API = nil
        exp = nil
    }

    func testNetworkingGroupsAPI() {
        API.getGroups(limit: 10, offset: 0).done({ (response) in
            print(response)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Unable to parse: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNetworkingTeachersAPI() {
        API.getTeachers(groupId: 3176).done({ (response) in
            print(response)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Unable to parse: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNetworkingSearchTeachersAPI() {
        API.searchTeachers(string: "Тел").done({ (response) in
            print(response)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Unable to parse: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNetworkingTimetableAPI() {
        API.getTimetable(groupId: 3176).done({ (response) in
            print(response)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Unable to parse: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

}
