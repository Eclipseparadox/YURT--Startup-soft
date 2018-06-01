//
//  DocumentFactories.swift
//  YURT
//
//  Created by Standret on 31.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class DocumentFactories {
    class func getTitle (type: DocumentType) -> String {
        var title: String!
        switch type {
            case .bank: title = "Bank assesments"
            case .cheque: title = "Void cheque"
            case .CPS: title = "Current pay stub"
            case .dlicense: title = "Driver's license"
            case .passport: title = "Passport"
            case .selfie: title = "Selfie"
            case .signature: title = "Your signature"
            case .SIN: title = "Social Insurance Card (SIN)"
            case .tax: title = "Tax assesments (2 years)"
            case .uBill: title = "Utility bill"
        }
        return title
    }
}
