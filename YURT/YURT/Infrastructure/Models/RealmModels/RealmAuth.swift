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
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var roles: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var imagePreview: String? = nil
    @objc dynamic var imageOrigin: String? = nil
    
    func deserialize() -> AuthApiModel {
        return AuthApiModel(access_token: "",
                            token_type: "",
                            id: id,
                            firstName: firstName,
                            lastName: lastName,
                            roles: roles,
                            email: email,
                            imagePreview: imagePreview,
                            imageOrigin: imageOrigin)
    }
}
