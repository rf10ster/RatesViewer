//
//  FlagServiceTests.swift
//  RatesViewerTests
//
//  Created by Aleksey Kiselev on 4/3/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import XCTest
@testable import RatesViewer

class FlagServiceTests: XCTestCase {
    
    var service: FlagService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        service = CircleFlagService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testServiceNotReturnResultsForFakeCurrency() {
        // given
        let currency = "РУБ"
        
        // when
        let flag = service.flag(currency)
        
        // then
        XCTAssertTrue(flag == nil, "Service should not found any flag for fake currency")
    }
    
    func testServiceReturnResultsForConcreteCurrency() {
        // given
        let currency = "GTQ"
        
        // when
        let flag = service.flag(currency)
        
        // then
        XCTAssertTrue(flag?.size.height == 15, "Flags framework contains only small assets")
    }
    
    func testServiceReturnDifferentResultsForDifferentCurrency() {
        // given
        let currency = "GTQ"
        let otherCurrency = "USD"
        
        // when
        let flag = service.flag(currency)
        let otherFlag = service.flag(otherCurrency)
        
        // then
        XCTAssertTrue(flag != nil && otherFlag != nil && flag != otherFlag, "Flags should be different")
    }
    
    func testServiceCaseSensetive() {
        // given
        let currency = "USD"
        let otherCurrency = "usd"
        
        // when
        let flag = service.flag(currency)
        let otherFlag = service.flag(otherCurrency)
        
        // then
        XCTAssertTrue(flag != otherFlag, "Flags should not be same")
        XCTAssertNil(otherFlag, "lowercase currency should not be found")
    }
    
}
