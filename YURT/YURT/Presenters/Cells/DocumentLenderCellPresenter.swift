//
//  DocumentLenderCellPresenter.swift
//  YURT
//
//  Created by Standret on 18.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol DocumentLenderCellDelegate {
    
}

class DocumentLenderCellPresenter: SttPresenter<DocumentLenderCellDelegate> {
    var fileUrl: String!
    
    convenience init (url: String) {
        self.init()
        fileUrl = url
    }
}
