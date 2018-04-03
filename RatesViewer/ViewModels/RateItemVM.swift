//
//  RateItemVM.swift
//  RatesViewer
//
//  Created by Алексей Киселев on 29/03/2018.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class RateItemVM: IdentifiableType {
    
    var identity: String {
        return currencyCode
    }
    
    let currencyCode: String
    let flagImage: UIImage?
    let rateValue: Variable<Double>
    private(set) var position: Int
    
    var currencyDescription: String? {
        get {
            return Locale.current.localizedString(forCurrencyCode: currencyCode)
        }
    }
    
    func update(rateValue: Double, position: Int) {
        self.rateValue.value = rateValue
        self.position = position
    }
    
    init(with currencyCode: String, rateValue: Double, position: Int, flagImage: UIImage?) {
        self.currencyCode = currencyCode
        self.rateValue = Variable(rateValue)
        self.flagImage = flagImage
        self.position = position
    }
}

extension RateItemVM: Hashable {
    
    var hashValue: Int {
        return currencyCode.hashValue
    }
    
    static func ==(lhs: RateItemVM, rhs: RateItemVM) -> Bool {
        return lhs.currencyCode == rhs.currencyCode
    }
}

extension RateItemVM: CustomStringConvertible {
    var description: String {
        return "RateItemVM: \(currencyCode), \(rateValue.value) at position \(position)"
    }
}
