//
//  SectionOfCurrencyData.swift
//  RatesViewer
//
//  Created by Aleksey Kiselev on 4/2/18.
//  Copyright © 2018 Aleksei Kiselev. All rights reserved.
//

import Foundation
import RxDataSources

struct MySection {
    var header: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = RateItemVM
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
