//
//  FlagService.swift
//  RatesViewer
//
//  Created by Aleksey Kiselev on 3/31/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import UIKit
import FlagKit

protocol FlagService {
    func flag(_ currencyCode: String) -> UIImage?
}

class FlagServiceMock: FlagService {
    let mockFlag = UIImage()
    func flag(_ currencyCode: String) -> UIImage? {
        return mockFlag
    }
}

class CircleFlagService: FlagService {
    
    private var flagByCurrencyCodeCache = [String: UIImage]()
    private let countryCodeByCurrencyCode: [String: String]
    
    init() {
        // store map between currencyCode and countryCode
        var countryCodeByCurrencyCode = [String: String]()
        for localeId in Locale.availableIdentifiers {
            let locale = Locale(identifier: localeId)
            if let countryCode = locale.regionCode,
                let currencyCode = locale.currencyCode {
                // special case for eu
                countryCodeByCurrencyCode[currencyCode] = currencyCode == "EUR" ? "EU" : countryCode
            }
        }
        self.countryCodeByCurrencyCode = countryCodeByCurrencyCode
    }
    
    func flag(_ currencyCode: String) -> UIImage? {
        guard let countryCode = self.countryCodeByCurrencyCode[currencyCode] else {
            return nil
        }
        if let flag = self.flagByCurrencyCodeCache[currencyCode] {
            return flag
        }
        if let notCachedFlag = Flag(countryCode: countryCode)?.image(style: .circle) {
            self.flagByCurrencyCodeCache[currencyCode] = notCachedFlag
            return notCachedFlag
        }
        return nil
    }
}
