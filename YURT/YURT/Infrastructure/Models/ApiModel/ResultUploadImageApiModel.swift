//
//  ResultUploadImageApiModel.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation

struct ResultUploadImageApiModel: Decodable, DictionaryCodable {
    let origin: ImageDataApiModel
    let preview: ImageDataApiModel
}

struct ImageDataApiModel: Decodable, DictionaryCodable {
    let path: String
    let weight: Int
    let height: Int
}
