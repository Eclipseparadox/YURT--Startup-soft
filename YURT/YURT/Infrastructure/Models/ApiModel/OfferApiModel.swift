//
//  OfferApiModel.swift
//  YURT
//
//  Created by Standret on 14.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum OfferStatus: Int, Decodable {
    case pending, approved, rejected
    
    func toString() -> String {
        switch self {
        case .approved: return "Approved"
        case .pending: return "Pending"
        case .rejected: return "Rejected"
        }
    }
}

struct LenderInfo: Decodable {
    let lenderId: String
    let fullName: String
    let physicalAddress: String
    let image: ResultUploadImageApiModel
}

struct OfferApiModel: Decodable {
    //let id: String
    let downPayment: Int
    let loan: Int
    let rate: Float
    let term: Int
    let amortization: Int
    let pmi: Double
    let lenderFees: Int
    let monthlyPayment: Double
    let hold: Int
    let description: String?
    let files: [String]
    let dateCreated: Date
    let status: OfferStatus
    let lender: LenderInfo
}
