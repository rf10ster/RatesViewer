//
//  RateListVM.swift
//  RatesViewer
//
//  Created by Алексей Киселев on 28/03/2018.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import UIKit
import Moya
import RxMoya
import RxSwift

class RateListVM {
    
    let baseCurrency: String
    
    let baseCurrencyAmount: Variable<Double> = Variable(1)
    let sections: Variable<[MySection]> = Variable([MySection]())
    
    private let provider: MoyaProvider<RatesService>
    private let flagService: FlagService
    private var cachedItems = Set<RateItemVM>()
    
    init(baseCurrency: String, provider: MoyaProvider<RatesService>, flagService: FlagService) {
        
        self.baseCurrency = baseCurrency
        
        self.provider = provider
        
        self.flagService = flagService
    }
    
    private func transformItems(from model: RateListModel) -> [RateItemVM] {
        if cachedItems.isEmpty {
            // first time
            for (index, rate) in model.rates.enumerated() {
                let item = RateItemVM(with: rate.currencyCode, rateValue: rate.rate, position: (index + 1), flagImage: flagService.flag(rate.currencyCode))
                cachedItems.insert(item)
            }
            let baseItemMock =  RateItemVM(with: baseCurrency, rateValue: 1, position: 0, flagImage: flagService.flag(baseCurrency))
            if cachedItems.contains(baseItemMock) == false {
                cachedItems.insert(baseItemMock)
            }
        } else {
            // update rates
            for rate in model.rates {
                let item = RateItemVM(with: rate.currencyCode, rateValue: rate.rate, position: (cachedItems.count + 1), flagImage: flagService.flag(rate.currencyCode))
                if let cachedIndex = cachedItems.index(of: item) {
                    let cachedItem = cachedItems[cachedIndex]
                    cachedItem.update(rateValue: item.rateValue.value, position: cachedItem.position)
                } else {
                    cachedItems.insert(item)
                }
            }
        }
        let sortedItems = cachedItems.sorted{ $0.position < $1.position }
        return sortedItems
    }
    
    func moveItemToTop(from index: Int) {
        guard index > 0 else {
            return
        }
        let sortedItems = cachedItems.sorted{ $0.position < $1.position }
        var firstPosition: Int = 0
        for (idx, item) in sortedItems.enumerated() {
            if idx == 0 {
                firstPosition = item.position
            }
            item.update(rateValue: item.rateValue.value, position: idx == index ? firstPosition : (item.position + 1))
            if idx == index {
                break
            }
        }
        
        self.sections.value = [MySection(header: "", items: cachedItems.sorted{ $0.position < $1.position })]
    }
    
    func fetch() {
        let _ = self.provider.rx.request(.baseCurrency(currencyCode: self.baseCurrency))
            .map(RateListModel.self)
            .subscribe { event in
                switch event {
                case let .success(model):
                    let items = self.transformItems(from: model)
                    self.sections.value = [MySection(header: "", items: items)]
                case let .error(error):
                    print(error)
                }
            }
    }
}
