//
//  ModelsDecodeTests.swift
//  RatesViewerTests
//
//  Created by Aleksey Kiselev on 4/3/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import XCTest
@testable import RatesViewer

class ModelsDecodeTests: XCTestCase {
    
    var jsonData: Data!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        jsonData = RatesService.baseCurrency(currencyCode: "NOT_MATTER").sampleData
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModelDecodingFromSampleData() {
        // given
        let rateListModel: RateListModel?
        
        // when
        rateListModel = try? JSONDecoder().decode(RateListModel.self, from: jsonData)
        
        // then
        XCTAssertTrue(rateListModel != nil, "RateListModel should be decoded from sample json data")
        XCTAssertTrue(rateListModel!.baseCurrencyCode == "EUR", "RateListModel from sample data should have baseCurrencyCode EUR")
        XCTAssertTrue(rateListModel!.rates.count == 32, "RateListModel from sample data should contains 32 RateItem model")
    }
    
    func testModelNotDecodingFromCorruptedData() {
        // given
        let rateListModel: RateListModel?
        let corruptedJsonData = "some corrupted data".data(using: .utf8)!
        
        // when
        rateListModel = try? JSONDecoder().decode(RateListModel.self, from: corruptedJsonData)
        
        // then
        XCTAssertTrue(rateListModel == nil, "RateListModel should not be decoded from corrupted json data")
    }
    
    
}
