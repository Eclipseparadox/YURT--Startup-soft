//
//  DocumentEntityPresenter.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

protocol DocumentEntityDelegate {
    
}

class DocumentEntityPresenter: SttPresenter<DocumentEntityDelegate> {
    
    var documentsName: String!
    var takesDate: Date!
    var isLoaded: Bool!
    
    convenience init (name: String) {
        self.init()
        documentsName = name
    }
}
