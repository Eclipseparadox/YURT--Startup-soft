//
//  ErrorModels.swift
//  YURT
//
//  Created by Standret on 16.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum BaseError: Error {
    case realmError(RealmError)
    case apiError(ApiError)
    case connectionError(ConnectionError)
    case jsonConvert(String)
    case unkown(String)
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .realmError(let concreate):
            let tempRes = concreate.getMessage()
            result = ("Realm: \(tempRes.0)", tempRes.1)
        case .apiError(let concreate):
            let tempRes = concreate.getMessage()
            result = ("Api: \(tempRes.0)", tempRes.1)
        case .connectionError(let concreate):
            let tempRes = concreate.getMessage()
            result = ("Connection: \(tempRes.0)", tempRes.1)
        case .jsonConvert(let message):
            result = ("Json convert", message)
        case .unkown(let message):
            result = ("Unkown", message)
        }
        
        return result
    }
}

enum RealmError {
    
    case objectIsSignleton(String)
    case notFoundObjects(String)
    case queryIsNull(String)
    case doesNotExactlyQuery(String)
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .objectIsSignleton(let message):
            result = ("singleton", message)
        case .notFoundObjects(let message):
            result = ("not found", message)
        case .queryIsNull(let message):
            result = ("query could not been nil", message)
        case .doesNotExactlyQuery(let message):
            result = ("query doesn not exactly", "found more one object or didn't find anything: \(message)")
        }
        return result
    }
}

enum ApiError {
    
    case badRequest(ServerError)
    case internalServerError(String)
    case otherApiError(Int)
    case responseIsNi
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .badRequest(let error):
            result = ("Bad request", "\(error.code): \(error.description)")
        case .internalServerError(let message):
            result = ("Internal Server Error", message)
        case .otherApiError(let code):
            result = ("Other", "with code: \(code)")
        case .responseIsNi:
            result = ("Response is nil", "Go to developer")
        }
        return result
    }
}

enum ConnectionError {
    case timeout
    case noInternetConnection
    case other(String)
    
    func getMessage() -> (String, String) {
        var result: (String, String)!
        switch self {
        case .noInternetConnection:
            result = ("No internet connection", "Check your settings or repeat later")
        case .timeout:
            result = ("Timeout", "Connectiom timeout")
        case .other(let message):
            result = ("Other", "with message: \(message)")
        }
        return result
    }
}
