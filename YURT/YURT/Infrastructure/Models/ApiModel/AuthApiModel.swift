//
//  AuthApiModel.swift
//  YURT
//
//  Created by Standret on 23.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct AuthApiModel: Decodable {
    let access_token: String
    let token_type: String
    let id: String
    let firstName: String
    let lastName: String
    let roles: String
    let email: String
    let imagePreview: String?
    let imageOrigin: String?
}
