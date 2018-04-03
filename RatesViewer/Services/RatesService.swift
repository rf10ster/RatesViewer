//
//  RatesService.swift
//  RatesViewer
//
//  Created by Алексей Киселев on 29/03/2018.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import Foundation
import Moya

enum RatesService {
    case baseCurrency(currencyCode: String)
}

extension RatesService: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://revolut.duckdns.org")! }
    
    var path: String {
        return "latest"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .baseCurrency(let currencyCode):
            return ["base": currencyCode]
        }
    }

    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        switch self {
        case .baseCurrency(_):
            return """
            {"base":"EUR","date":"2018-03-28","rates":
                {"AUD":1.6162,"BGN":1.9594,"BRL":4.134,"CAD":1.6003,"CHF":1.1823,"CNY":7.8114,"CZK":25.509,"DKK":7.4649,"GBP":0.87765,"HKD":9.7473,"HRK":7.4564,"HUF":313.08,"IDR":17089.0,"ILS":4.3432,"INR":80.948,"ISK":121.72,"JPY":131.84,"KRW":1323.9,"MXN":22.814,"MYR":4.7908,"NOK":9.66,"NZD":1.7106,"PHP":64.992,"PLN":4.2149,"RON":4.661,"RUB":71.456,"SEK":10.299,"SGD":1.6244,"THB":38.815,"TRY":4.9652,"USD":1.2421,"ZAR":14.529}}
            """.data(using: .utf8)!
        }
    }
}
