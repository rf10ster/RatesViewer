//
//  RateListVMTests.swift
//  RatesViewerTests
//
//  Created by Aleksey Kiselev on 4/3/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import Moya
@testable import RatesViewer

class RateListVMTests: XCTestCase {
    
    var provider: MoyaProvider<RatesService>!
    var flagService: FlagService!
    let baseCurrency = "EUR"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        flagService = FlagServiceMock()
        provider = MoyaProvider<RatesService>(stubClosure: MoyaProvider.immediatelyStub)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchingFillsItemsAndFirstIsBase() {
        // given
        let itemEUR: RateItemVM = RateItemVM(with: baseCurrency, rateValue: 1, position: 0, flagImage: UIImage())
        let vm = RateListVM(baseCurrency: baseCurrency, provider: provider, flagService: flagService)
        
        // when
        vm.fetch()
        
        // then
        XCTAssertEqual(vm.sections.value.count, 1)
        XCTAssertEqual(vm.sections.value[0].items.count, 32)
        XCTAssertEqual(vm.sections.value[0].items.first, itemEUR)
    }
    
    func testFetchedItemsChangePositionsLikeCarousel() {
        // given
        let vm = RateListVM(baseCurrency: baseCurrency, provider: provider, flagService: flagService)
        vm.fetch()
        let items = vm.sections.value[0].items
        let itemEUR: RateItemVM = items[0]
        let itemSecond: RateItemVM = items[1]
        let itemThird: RateItemVM = items[2]
        
        // when
        vm.moveItemToTop(from: 2)
        let itemsMoved = vm.sections.value[0].items
        
        // then
        XCTAssertEqual(itemsMoved.first, itemThird)
        XCTAssertEqual(itemsMoved[1], itemEUR)
        XCTAssertEqual(itemsMoved[2], itemSecond)
    }
    
    func testDatasourceSignals() {
        
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver([MySection].self)
        let rx_disposeBag = DisposeBag()
        
        let vm = RateListVM(baseCurrency: baseCurrency, provider: provider, flagService: flagService)
        vm.sections.asObservable().subscribe(observer).disposed(by: rx_disposeBag)
        vm.fetch()
        let items = vm.sections.value[0].items
        let itemThird: RateItemVM = items[2]
        
        // when
        testScheduler.start()
        vm.moveItemToTop(from: 2)
        
        // then
        XCTAssertEqual(observer.events.count, 3) // 0 elements, fill elements, reorder elements
        XCTAssertTrue(observer.events[0].value.element!.count == 0)
        XCTAssertEqual(observer.events[1].value.element!.count, observer.events[2].value.element!.count)
        XCTAssertEqual(observer.events[2].value.element![0].items.first, itemThird)
    }
    
}
