//
//  NewLendersPresenter.swift
//  YURT
//
//  Created by Standret on 13.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol NewLendersDelegate: BaseLenderProtocol {
    
}

class NewLendersPresenter: BaseLendersPresenter<NewLendersDelegate> {

    override func presenterCreating() {
        type = OfferStatus.pending
        super.presenterCreating()
    }
}
