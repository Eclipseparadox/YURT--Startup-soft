//
//  DocumentsEntityHeaderPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol DocumentsEntityHeaderDelegate {
    
}

class DocumentsEntityHeaderPresenter: SttPresenter<DocumentsEntityHeaderDelegate> {
    
    var title: String!
    var uploadedsCount: Int = 0
    var isError: Bool?
    var totalCountDocument: Int!
    
    convenience init (title: String, total: Int) {
        self.init()
        self.title = title
        self.totalCountDocument = total
    }
}
