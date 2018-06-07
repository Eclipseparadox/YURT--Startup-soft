//
//  ShowPhotoPresenter.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit

protocol ShowPhotoDelegate: Viewable {
    func reloadData(type: DocumentType, image: Image)
}

class ShowPhotoPresenter: SttPresenter<ShowPhotoDelegate> {
    
    var id: String!
    
    var _documentService: DocumentServiceType!
    var deleteCommand: SttComand!
    
    override func prepare(parametr: Any?) {
        ServiceInjectorAssembly.instance().inject(into: self)

        let param = parametr as! (DocumentType, Image, String)
        
        id = param.2
        delegate!.reloadData(type: param.0, image: param.1)
        
        deleteCommand = SttComand(delegate: self, handler: { $0.onDelete() })
    }
    
    func onDelete() {
        _ = deleteCommand.useWork(observable: _documentService.deleteDocument(id: id))
            .subscribe(onNext: { [weak self] res in
                self?.delegate?.close(parametr: res)
            })
    }
}
