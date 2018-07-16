//
//  OfferDetailPresenter.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum OfferDetailType {
    case currency
    case percent
    case years
    case months
    case count
    case days
}

protocol OfferDetailDelegate {
    
}

class OfferDetailPresenter: SttPresenter<OfferDetailDelegate> {
    var name: String!
    var value: Double!
    var type: OfferDetailType!
    
    convenience init (name: String, value: Double, type: OfferDetailType) {
        self.init()
        self.name = name
        self.value = value
        self.type = type
    }
}
