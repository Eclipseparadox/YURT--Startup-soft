//
//  ProfileEditItemCellPresenter.swift
//  YURT
//
//  Created by Standret on 04.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class ProfileEditItemPresenter: SttPresenter<SttViewable> {
    var identifier: String!
    
    convenience init(identifier: String) {
        self.init()
        
        self.identifier = identifier
    }
}
