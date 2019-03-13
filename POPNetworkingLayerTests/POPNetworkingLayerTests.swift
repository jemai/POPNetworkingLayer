//
//  POPNetworkingLayerTests.swift
//  POPNetworkingLayerTests
//
//  Created by Abdelhak Jemaii on 13.03.19.
//  Copyright © 2019 Abdelhak Jemaii. All rights reserved.
//

import XCTest
@testable import POPNetworkingLayer

class POPNetworkingLayerTests: XCTestCase {
    
    struct service: Requester { }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testService() {
        
    }

    func testPerformanceExample() {
        // preparing the request
        let request = HTTPRequest(url: "http://ip.jsontest.com/")
        //
        weak var expect = expectation(description: "Service Call Expectation")
        //
        self.measure {
            // loading the object from remote
            service.execute(ofType: ResponseMapper.self, request: request) { (result) in
                switch result {
                case .failure(let error):
                    XCTFail("Error happened: \(error.debugDescription)")
                case .success( _):
                    XCTAssert(true)
                }
                expect?.fulfill()
                expect = nil
            }
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Timeout errored: \(error)")
            }
        }
    }

}


struct ResponseMapper: Codable {
    let ip: String
}
