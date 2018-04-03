//
//  RatesServiceTests.swift
//  RatesViewerTests
//
//  Created by Aleksey Kiselev on 4/3/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import XCTest
import Moya
@testable import RatesViewer

class RatesServiceTests: XCTestCase {
    
    var provider: MoyaProvider<RatesService>!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        provider = MoyaProvider<RatesService>(stubClosure: MoyaProvider.immediatelyStub)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServiceReturnStubbedDataForRequestAndCompletionHandlerExecutedOnMainThread() {
        // given
        let promise = expectation(description: "Executed")
        var message: String?
        let target: RatesService = .baseCurrency(currencyCode: "NOT_MATTER_FOR_STUBBED")
        var calledImMain = false
        
        // when
        provider.request(target) { result in
            if case let .success(response) = result {
                message = String(data: response.data, encoding: .utf8)
            }
            calledImMain = Thread.isMainThread
            promise.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        // then
        let sampleData = target.sampleData
        XCTAssertEqual(String(data: sampleData, encoding: .utf8), message, "Service should return stubbed result")
        XCTAssertTrue(calledImMain, "Service should call completion on main thread")
    }
    
}
