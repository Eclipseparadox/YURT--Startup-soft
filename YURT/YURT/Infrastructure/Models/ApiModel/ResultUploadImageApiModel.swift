//
//  ResultUploadImageApiModel.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct ResultUploadImageApiModel: Decodable, Encodable {
    let origin: ImageDataApiModel
    let preview: ImageDataApiModel
    
    func getDictionary() -> [String: Any] {
        return [
            "origin": origin.getDictionary(),
            "preview": preview.getDictionary()
        ]
    }
}

struct ImageDataApiModel: Decodable, Encodable {
    let path: String
    let weight: Int
    let height: Int
    
    func getDictionary() -> [String: Any] {
        return [
            "path": path,
            "weight": weight,
            "height": height
        ]
    }
}
