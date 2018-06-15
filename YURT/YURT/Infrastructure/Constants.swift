//
//  Constants.swift
//  YURT
//
//  Created by Standret on 03.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum ApiConroller {
    case token
    case account(String)
    case mobileAccount(String)
    case mobileDocument(String)
    case mobileOffers(String)
    case upload(String)
    case users(String)
    
    func get() -> String {
        switch self {
        case .token:
            return "api/token"
        case .account(let method):
            return "\(Constants.versionApi)account/\(method)"
        case .mobileAccount(let method):
            return "\(Constants.versionApi)mobile/account/\(method)"
        case .mobileDocument(let method):
            return "\(Constants.versionApi)mobile/documents/\(method)"
        case .mobileOffers(let method):
            return "\(Constants.versionApi)mobile/offers/\(method)"
        case .upload(let method):
            return "\(Constants.versionApi)upload/\(method)"
        case .users(let method):
            return "\(Constants.versionApi)users/\(method)"
        }
    }
}

class Constants {
    // url
    static let apiUrl = "https://qa-startupsoft-imx.azurewebsites.net/"
    static let blobUrl = "https://prodssanalyticsstorage.blob.core.windows.net"
    static let versionApi = "api/v1/"
    
    // keychain id
    static let tokenKey = "securityAccessToken"
    static let idKey = "securityUserId"
    
    // api config
    static let maxImageCacheSize = 1024 * 1024 * 200
    static let maxCacheAge = 60 * 60 * 24 * 7 * 4
    static let timeout = TimeInterval(15) + TimeInterval(timeWaitNextRequest)
    static let timeWaitNextRequest = UInt32(2)
    static let maxCountRepeatRequest = 3
    
    // error string
    static let incorrectLogin = "Email or Password is incorrect."
    
    // image key
    static let avatarPlaceholder = "avatarPlaceholder"
    
    // realm
    static let keySingle = "--single--"
    
    // log - key
    static let httpKeyLog = "HTTP"
    static let apiDataKeyLog = "APIDP"
    static let repositoryLog = "RealmRep"
    static let repositoryExtensionsLog = "RealmEXTRep"
    static let noImplementException = "No implement exception"
    
    // validation pattern and option
    
    static let emailPattern = "^([A-Za-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)$"
    static let passwordPattern = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,40}$"
    static let firstNamePattern = "^[A-Za-z0-9 _.,'()-]{1,60}$"
    static let lastNamePattern = "^[A-Za-z0-9 _.,'()-]{1,60}$"
    static let phoneNumber = "^(\\+?[0-9 ()-]){10,25}$"
    
    static let passwordRequiered = "A digit, a lowercase, an uppercase are required"
    
    static let minPassword = 6
    static let maxPassword = 40
    static let minFirstName = 1
    static let maxFirstName = 60
    static let minLastName = 1
    static let maxLastName = 60
    static let minLocation = 1
    static let maxLocation = 150
    static let minPhone = 10
    static let maxPhone = 25
}
