//
//  RateItemVMTests.swift
//  RatesViewerTests
//
//  Created by Aleksey Kiselev on 4/3/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RatesViewer

class RateItemVMTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRateItemVMupdating() {
        // given
        let initialRateValue: Double = 210
        let initialPosition = 3
        let vm: RateItemVM = RateItemVM(with: "RUB", rateValue: initialRateValue, position: initialPosition, flagImage: nil)
        let rateValue: Double = 125
        let position = 1

        // when
        vm.update(rateValue: rateValue, position: position)
        
        // then
        XCTAssertTrue(vm.currencyCode == "RUB")
        XCTAssertTrue(vm.currencyDescription != nil && vm.currencyDescription!.isEmpty == false)
        XCTAssertTrue(vm.position == position)
        XCTAssertTrue(vm.rateValue.value == rateValue)
    }
    
    func testRateItemVMemitsRateUpdatingEvents() {
        // given
        let initialRateValue: Double = 210
        let initialPosition = 3
        let vm: RateItemVM = RateItemVM(with: "RUB", rateValue: initialRateValue, position: initialPosition, flagImage: nil)
        let testScheduler = TestScheduler(initialClock: 0)
        let rateObserver = testScheduler.createObserver(Double.self)
        
        let rx_disposeBag = DisposeBag()
        
        let rateValue: Double = 125
        let position = 1

        // when
        vm.rateValue.asObservable().subscribe(rateObserver).disposed(by: rx_disposeBag)
        testScheduler.start()
        vm.update(rateValue: rateValue, position: position)
        
        // then
        let rateValues = [
            next(0, initialRateValue),
            next(0, rateValue)
        ]
        XCTAssertEqual(rateObserver.events, rateValues)
    }
    
}
