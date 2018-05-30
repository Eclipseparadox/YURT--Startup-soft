//
//  AccountModel.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct BorrowerSignUp: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let phoneNumber: String?
    let location: String?
    let image: ResultUploadImageApiModel?
    
    func getDictionary() -> [String: Any] {
        return [
            "FirstName": firstName,
            "LastName": lastName,
            "Email": email,
            "Password": password,
            "PhoneNumber": phoneNumber,
            "Location": location,
            "Image": image?.getDictionary()
        ]
    }
}
