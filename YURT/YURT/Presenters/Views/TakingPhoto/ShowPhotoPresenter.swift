//
//  ShowPhotoPresenter.swift
//  YURT
//
//  Created by Standret on 04.06.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

struct ShowPhotoNavigateModel {
    let title: String
    let image: Image
    let id: String?
}

protocol ShowPhotoDelegate: SttViewContolable {
    func reloadData(title: String, image: Image)
}

class ShowPhotoPresenter: SttPresenter<ShowPhotoDelegate> {
    
    var id: String?
    
    var _documentService: DocumentServiceType!
    var deleteCommand: SttComand!
    
    override func prepare(parametr: Any?) {
        ServiceInjectorAssembly.instance().inject(into: self)

        let param = parametr as! ShowPhotoNavigateModel
        
        id = param.id
        delegate!.reloadData(title: param.title, image: param.image)
        
        deleteCommand = SttComand(delegate: self, handler: { $0.onDelete() }, handlerCanExecute: { $0.id != nil })
    }
    
    func onDelete() {
        _ = deleteCommand.useWork(observable: _documentService.deleteDocument(id: id!))
            .subscribe(onNext: { [weak self] res in
                self?.delegate?.close(parametr: res)
            })
    }
}
