//
//  RejectedLendersPresenter.swift
//  YURT
//
//  Created by Standret on 13.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol RejectedLendersDelegate: BaseLenderProtocol {
    
}

class RejectedLendersPresenter: BaseLendersPresenter<RejectedLendersDelegate> {
    
    override func presenterCreating() {
        type = OfferStatus.rejected
        
        super.presenterCreating()
    }
}
