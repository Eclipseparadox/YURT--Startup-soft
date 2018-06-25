//
//  AddDocumentApiModel.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum DocumentTypeApiModel: Int, Codable {
    case personal, financial, property
}

class AddDocumentApiModel: Codable {
    var id: String?
    var type: DocumentTypeApiModel!
    var image: ResultUploadImageApiModel!
    var name: DocumentType!
    
    init (id: String?, type: DocumentTypeApiModel, docType: DocumentType, image: ResultUploadImageApiModel) {
        self.id = id
        self.type = type
        self.image = image
        self.name = docType
    }
}
