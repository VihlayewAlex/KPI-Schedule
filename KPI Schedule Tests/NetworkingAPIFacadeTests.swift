//
//  NetworkingAPIFacadeTests.swift
//  KPI Schedule Tests
//
//  Created by Alex Vihlayew on 3/6/19.
//  Copyright © 2019 Oleksandr Vikhliaiev. All rights reserved.
//

import XCTest

class NetworkingAPIFacadeTests: XCTestCase {

    var APIFacade: NetworkingApiFacade!
    var exp: XCTestExpectation!
    
    override func setUp() {
        APIFacade = NetworkingApiFacade(apiService: NetworkingApi())
        exp = expectation(description: "Correctly abstract Networking API")
    }

    override func tearDown() {
        APIFacade = nil
        exp = nil
    }

    func testGetAllGroups() {
        var groups = [GroupInfo]()
        APIFacade.getAllGroups(packedBy: 20, callbackQueue: DispatchQueue.main) { (handler) in
            switch handler {
            case .failure(let error):
                XCTFail("Error: " + error.localizedDescription)
                self.exp.fulfill()
            case .success(let packet):
                print(packet)
                groups += packet.nextPacket
                if packet.isLast {
                    XCTAssert(groups.count == packet.totalCount, "Total group count is not correct")
                    self.exp.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testGetGroupSchedule() {
        APIFacade.getSchedule(forGroupWithId: 3176, allowCached: false).done({ (schedule) in
            print(schedule)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Error: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetAllGroupTeachers() {
        APIFacade.getTeachers(forGroupWithId: 3176).done({ (teachers) in
            print(teachers)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Error: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSearchTeachers() {
        APIFacade.searchTeachers(byString: "Гав").done({ (teachers) in
            print(teachers)
            self.exp.fulfill()
        }).catch({ (error) in
            XCTFail("Error: " + error.localizedDescription)
            self.exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }

}
