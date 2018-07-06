//
//  ProfileApiModel.swift
//  YURT
//
//  Created by Standret on 05.07.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct ProfileApiModel: Decodable {
    let id: String
    let image: ResultUploadImageApiModel?
    let firstName: String
    let lastName: String
    let linkedInUrl: String?
    let phoneNumber: String
    let email: String
    let skype: String?
    let location: String
    let education: String?
    let work: String?
}
