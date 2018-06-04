//
//  AddDocumentApiModel.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

enum DocumentTypeApiModel: Int, DictionaryCodable {
    case personal, financial, property
}

class AddDocumentApiModel: DictionaryCodable {
    var id: String?
    var type: DocumentTypeApiModel!
    var image: ResultUploadImageApiModel!
    
    init (id: String?, type: DocumentTypeApiModel, image: ResultUploadImageApiModel) {
        self.id = id
        self.type = type
        self.image = image
    }
}
