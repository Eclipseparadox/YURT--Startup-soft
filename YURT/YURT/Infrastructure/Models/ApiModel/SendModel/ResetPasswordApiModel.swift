//
//  ResetPasswordApiModel.swift
//  YURT
//
//  Created by Standret on 16.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct ResetPasswordApiModel: Codable {
    let code: String
    let email: String
    let password: String
    let confirmPassword: String
}
