//
//  RealmAuth.swift
//  YURT
//
//  Created by Piter Standret on 6/4/18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class RealmAuth: SttRealmObject, RealmDecodable {
    
    typealias TTarget = AuthApiModel
    
    @objc dynamic var roles: String = ""
    
    func deserialize() -> AuthApiModel {
        return AuthApiModel(access_token: "", token_type: "", id: id, roles: roles)
    }
}
