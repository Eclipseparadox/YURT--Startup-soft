//
//  DeleteDocumentApiModel.swift
//  YURT
//
//  Created by Standret on 06.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

class DeleteDocumentApiModel: DictionaryCodable {
    var documentId: String!
    var image: ImageDataApiModel!
    
    init (documentId: String, image: ImageDataApiModel) {
        self.documentId = documentId
        self.image = image
    }
}
