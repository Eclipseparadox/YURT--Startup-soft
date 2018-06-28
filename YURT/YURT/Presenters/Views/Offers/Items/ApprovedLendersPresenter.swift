//
//  ApprovedLendersPresenter.swift
//  YURT
//
//  Created by Standret on 13.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol ApprovedLendersDelegate: BaseLenderProtocol {
    
}

class ApprovedLendersPresenter: BaseLendersPresenter<ApprovedLendersDelegate> {

    override func presenterCreating() {
        type = OfferStatus.approved
        super.presenterCreating()
        
    }
}
