//
//  RateListModel.swift
//  RatesViewer
//
//  Created by Алексей Киселев on 28/03/2018.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import Foundation

struct RateListModel {
    let baseCurrencyCode: String
    let date: String // let it be string for simplicity
    let rates: [RateItem]
}

extension RateListModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case baseCurrencyCode = "base"
        case date
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baseCurrencyCode = try values.decode(String.self, forKey: .baseCurrencyCode)
        date = try values.decode(String.self, forKey: .date)
        let ratesDictionary = try values.decode([String: Double].self, forKey: .rates)
        rates = ratesDictionary.flatMap { RateItem(currencyCode: $0.key, rate: $0.value) }
    }
}
