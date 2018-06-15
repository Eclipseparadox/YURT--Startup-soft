//
//  LenderPresenter.swift
//  YURT
//
//  Created by Standret on 12.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol LenderDelegate {
    
}

protocol OfferItemDelegate: class {
    func openOffers(id: String)
}

class LenderPresenter: SttPresenter<LenderDelegate> {
    
    var data: OfferApiModel!
    let id: String = UUID().uuidString
    weak var itemDelegate: OfferItemDelegate?
    
    convenience init (data: OfferApiModel) {
        self.init()
        self.data = data
    }
    
    func openOffers() {
        itemDelegate?.openOffers(id: id)
    }
}
