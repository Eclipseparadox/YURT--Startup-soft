//
//  BaseRealm.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RealmSwift

class BaseRealm: Object {
    @objc dynamic var id: String = Constants.keySingle
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var dateUpdated: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class RealmString: Object {
    @objc dynamic var value: String = ""
}
