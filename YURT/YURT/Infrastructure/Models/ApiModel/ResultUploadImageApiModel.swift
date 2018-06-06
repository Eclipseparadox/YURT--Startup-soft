//
//  ResultUploadImageApiModel.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct ResultUploadImageApiModel: Decodable, RealmCodable, DictionaryCodable {
    
    typealias TTarget = RealmUploadImage
    
    let origin: ImageDataApiModel
    let preview: ImageDataApiModel
    
    func serialize() -> RealmUploadImage {
        return RealmUploadImage(value: [
            "origin": origin.serialize(),
            "preview": preview.serialize()
            ])
    }
}

struct ImageDataApiModel: Decodable, RealmCodable, DictionaryCodable {
    
    typealias TTarget = RealmImageData
    
    let path: String
    let weight: Int
    let height: Int
    
    func serialize() -> RealmImageData {
        return RealmImageData(value: [
            "path": path,
            "weight": weight,
            "height": height
            ])
    }
}
