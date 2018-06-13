//
//  RejectedLendersPresenter.swift
//  YURT
//
//  Created by Standret on 13.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol RejectedLendersDelegate {
    
}

class RejectedLendersPresenter: SttPresenter<RejectedLendersDelegate> {
    var lenders = [LenderPresenter]()
    
    override func presenterCreating() {
        super.presenterCreating()
        
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
        lenders.append(LenderPresenter())
    }
}
