//
//  AuthApiModel.swift
//  YURT
//
//  Created by Standret on 23.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct AuthApiModel: Decodable, RealmCodable {
   
    typealias TTarget = RealmAuth
    
    let access_token: String
    let token_type: String
    let id: String
    let roles: String
    
    func serialize() -> RealmAuth {
        return RealmAuth(value: ["id": id,
                                 "roles": roles,
                                 ])
    }
}
