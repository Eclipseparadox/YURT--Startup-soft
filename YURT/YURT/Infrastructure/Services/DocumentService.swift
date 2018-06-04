//
//  DocumentService.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol DocumentServiceType {
    func uploadDocument(type: DocumentType, image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<Bool>
}

class DocumentService: DocumentServiceType {
    
    var _apiService: IApiService!
    var _notificatonError: INotificationError!
    var _unitOfWork: IUnitOfWork!
    
    init () {
        ServiceInjectorAssembly.instance().inject(into: self)
    }
    
    func uploadDocument(type: DocumentType, image: UIImage, progresHandler: ((Float) -> Void)?) -> Observable<Bool> {
        let _type = type.isFinancies() ? DocumentTypeApiModel.financial : DocumentTypeApiModel.personal
        return _notificatonError.useError(observable: _apiService.uploadImage(image: image, progresHandler: progresHandler)
            .flatMap( { self._apiService.addDocument(model: AddDocumentApiModel(id: nil, type: _type, image: $0)) } ))
        
    }
    
    
}
