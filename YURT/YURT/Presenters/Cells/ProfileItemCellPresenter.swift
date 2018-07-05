//
//  ProfileItemCellPresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class ProfileItemPresenter: SttPresenter<SttViewable> {
    var key: String!
    var value: String!
    
    convenience init(key: String, value: String) {
        self.init()
        
        self.key = key
        self.value = value
    }
}
