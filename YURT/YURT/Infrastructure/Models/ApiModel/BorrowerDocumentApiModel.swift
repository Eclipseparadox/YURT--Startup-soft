//
//  BorrowerApiModel.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum DocumentStatus: Int, Decodable {
    case Pending, Approved, Rejected
}

struct BorrowerDocumentApiModel: Decodable, RealmCodable {
    
    typealias TTarget = RealmBorrowerDocument
    
    let id: String
    let type: DocumentTypeApiModel
    let documentStatus: DocumentStatus
    let name: DocumentType
    let image: ResultUploadImageApiModel
    let lastUpdate: Date
    
    func serialize() -> RealmBorrowerDocument {
        return RealmBorrowerDocument(value: [
            "id": id,
            "image": image.serialize(),
            "_documentStatus": documentStatus.rawValue,
            "_type": type.rawValue,
            "_name": name.rawValue,
            "lastUpdate": lastUpdate
            ])
    }
}
