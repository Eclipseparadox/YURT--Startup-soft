//
//  RealmBorrowerDocument.swift
//  YURT
//
//  Created by Standret on 05.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RealmSwift

class RealmImageData: Object, RealmDecodable {
    
    typealias TTarget = ImageDataApiModel
    
    @objc dynamic var path: String = ""
    @objc dynamic var weight: Int = 0
    @objc dynamic var height: Int = 0
    
    func deserialize() -> ImageDataApiModel {
        return ImageDataApiModel(path: path, weight: weight, height: height)
    }
}


class RealmUploadImage: Object, RealmDecodable {
    
    typealias TTarget = ResultUploadImageApiModel
    
    @objc dynamic var origin: RealmImageData? = RealmImageData()
    @objc dynamic var preview: RealmImageData? = RealmImageData()
    
    func deserialize() -> ResultUploadImageApiModel {
        return ResultUploadImageApiModel(origin: origin!.deserialize(), preview: preview!.deserialize())
    }
}

class RealmBorrowerDocument: BaseRealm, RealmDecodable {
    
    typealias TTarget = BorrowerDocumentApiModel
    
    @objc dynamic var image: RealmUploadImage? = RealmUploadImage()
    @objc dynamic var lastUpdate: Date = Date()
    
    @objc private dynamic var _documentStatus = DocumentStatus.Approved.rawValue
    @objc private dynamic var _type = DocumentTypeApiModel.financial.rawValue
    @objc private dynamic var _name = DocumentType.bank.rawValue
    
    var documentStatus: DocumentStatus {
        get { return DocumentStatus(rawValue: _documentStatus)! }
        set { _documentStatus = newValue.rawValue }
    }
    var type: DocumentTypeApiModel {
        get { return DocumentTypeApiModel(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    var name: DocumentType {
        get { return DocumentType(rawValue: _name)! }
        set { _name = newValue.rawValue }
    }
    
    func deserialize() -> BorrowerDocumentApiModel {
        return BorrowerDocumentApiModel(id: id, type: type, documentStatus: documentStatus, name: name, image: image!.deserialize(), lastUpdate: lastUpdate)
    }
}
